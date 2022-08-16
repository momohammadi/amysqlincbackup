#!/bin/sh
############################################################################
# Author : Morteza Saeed Mohammadi                                         #
# Email  : m.mohammadi721@gmail.com                                        #
# License : GNU General Public License v3.0                                #
# gitub : https://github.com/momohammadi/amysqlincbackup                   #
############################################################################
source /opt/amysqlincbackup/amysqlincbackup.cnf
# set up the date variable
NOW=$(date +%Y-%m-%d_%H-%M-%S)
TIME=`printf "%(%H%M)T"`

BINLOG_BACKUP=${NOW}_binlog.tar.gz 
FULL_BACKUP=${NOW}_fullbackup.sql
FULL_BACKUP_FILE=$BACKUP_DIR$FULL_BACKUP 
FULL_BACKUP_LOCK="Full_Backup_Info"
if [ ! -f "$BACKUP_DIR$FULL_BACKUP_LOCK" ]
then
        echo "MySql Full Backup is Running" > $BACKUP_DIR$FULL_BACKUP_LOCK
	# Create Full Backup and deletes any old binary log files
	mysqldump --flush-logs --delete-master-logs --all-databases -u$DB_USER -p"$DB_PASSWORD" -h "$DB_HOST" -p "$DB_PORT" > $FULL_BACKUP_FILE
	if [ "$COMPRESS_FULL_BACKUP" == "yes" ]
	then
		tar -C $BACKUP_DIR -czvf $FULL_BACKUP_FILE.tar.gz $FULL_BACKUP
		rm -rf $FULL_BACKUP_FILE
	fi
        echo "MySql Full Backup Complete at $(date +%Y-%m-%d_%H-%M-%S)" > $BACKUP_DIR$FULL_BACKUP_LOCK
        find $BACKUP_DIR*_fullbackup.tar.gz -mtime +$DELETE_FULL_BACKUP -exec rm -rf {} \; 2>/dev/null
        if [ "$DELETE_INC_BACKUP" == "yes" ]
        then
                find $BACKUP_DIR*_binlog.tar.gz -mmin +1 -exec rm -rf {} \; 2>/dev/null
        fi
	# exit script after create full backup
	exit 0
elif ! grep -q "`date +%Y-%m-%d`" $BACKUP_DIR$FULL_BACKUP_LOCK; then
	# Remove lock file for create new full backup on next cron
        rm -rf $BACKUP_DIR$FULL_BACKUP_LOCK
fi

# flush the current log and start writing to a new binary log file
mysql -u$DB_USER -p$DB_PASSWORD -h $DB_HOST -p $DB_PORT -E --execute='FLUSH BINARY LOGS;' mysql

# get a list of all binary log files
BINLOGS=$(mysql -u$DB_USER -p"$DB_PASSWORD" -h $DB_HOST -p $DB_PORT -E --execute='SHOW BINARY LOGS;' mysql | grep Log_name | sed -e 's/Log_name://g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

# get the most recent binary log file
BINLOG_CURRENT=`echo "${BINLOGS}" | tail -n -1`

# get list of binary logs to be backed up (everything except the most recent one)
BINLOGS_FOR_BACKUP=`echo "${BINLOGS}" | head -n -1`

# create a list of the full paths to the binary logs to be backed up
BINLOGS_FULL_PATH=`echo "${BINLOGS_FOR_BACKUP}" | xargs -I % echo $BINLOGS_PATH%`

# compress the list of binary logs to be backed up into an archive in the backup location
        if [ "$COMPRESS_INC_BACKUP" == "yes" ]
        then
		tar -czvf $BACKUP_DIR$BINLOG_BACKUP $BINLOGS_FULL_PATH 2>/dev/null
	else
		cp -r $BINLOGS_FULL_PATH $BACKUP_DIR
	fi
	

# delete the binary logs that have been backed up
echo $BINLOG_CURRENT | xargs -I % mysql -u$DB_USER -p$DB_PASSWORD -h $DB_HOST -p $DB_PORT -E --execute='PURGE BINARY LOGS TO "%";' mysql
