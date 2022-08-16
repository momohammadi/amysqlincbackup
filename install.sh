#!/bin/sh
cp -r amysqlincbackup /opt/
touch /etc/cron.d/amysqlincbackup
echo "*/60 * * * * root /bin/bash /opt/amysqlincbackup.sh" > /etc/cron.d/amysqlincbackup
echo "Installation has been complete"\n