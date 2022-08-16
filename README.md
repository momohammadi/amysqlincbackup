# amysqlincbackup
Automated MySQL/MariaDB Incremental Backup (amysqlincbackup) is the simple solution for creating incremental backups from MySQL or MariaDB on any Linux Distro.

### What is incremental backup?
An incremental backup is a backup type that only copies data that has been changed or created since the previous backup activity was conducted. An incremental backup approach is used when the amount of data that has to be protected is too voluminous to do a full backup of that data every day. By only backing up changed data, incremental backups save restore time and disk space and also bandwidth usage if you want to save the backups out of the local host. Incremental is a standard method for cloud backup as it tends to use fewer resources.

### What's doing amysqlincbackup ?
amysqlincbackup is here for save your time for setup MySQL incremental backup, this script do every-thing you need to do it from scratch to create, schedule and save.

### how amysqlincbackup work?
MySQL Enterprise offers incremental backups among its many features, but it comes with a significant price tag. Luckily, there is a way to create incremental backups in the free version of MySQL.

First you need to enable the MySQL binary log. This is a log of all database changes that have occurred on the MySQL server, known as “events.” The binary log is off by default, but you can enable it by updating the right MySQL configuration file.

### amysqlincbackup road map
In the first version, it is just a simple script to create and schedule MySQL/MariaDB incremental backup, but I prefer to work in the next step by adding auto-installation plus easy restoration.
Finally, my opinion is this can convert to the complete tool for auto incremental backup including upload to cloud, etc.
following and add star can give me the power to continue

## Installation
##### Install scripts
```bash
git clone https://github.com/momohammadi/amysqlincbackup.git
cd amysqlincbackup
chmod +x install.sh
./install.sh
```
#### Enable binary log on MySQL
if you did not enable binary log, first find right mysql config file then add this line in `[mysqld]` section
```bash
#enable binary log for mysql
log-bin = /var/lib/mysql/mysql-bin
#purge automaticly binary log after x days
expire_logs_days = 10
# see more about his line on https://mariadb.com/kb/en/binary-log-formats/
binlog_format = row
```
###Change settings
setup your value on /opt/amysqlincbackup/amysqlincbackup.cnf
Enter Your Backup Directory  *end of slash(/) - where the backup will be save
`BACKUP_DIR=`
Delete Full Mysql Backup Older Than x Day
`DELETE_FULL_BACKUP='
Delete Previous Incremental Backup After each Full Backup (yes|no)
`DELETE_INC_BACKUP=`
Compress Full backup files (yes|no) 
`COMPRESS_FULL_BACKUP=`
Compress Incremental backup files (yes|no)
`COMPRESS_INC_BACKUP=`
MySQL binary log files directory path *end of slash(/)
`BINLOGS_PATH=`
set up the database credentials (dbadmin user and password)
`DB_USER=`
`DB_PASSWORD=`
`DB_HOST=`