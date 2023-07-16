#!/bin/bash

touch /mongo_backup.log
tail -F /mongo_backup.log &

if [ -n "${INIT_BACKUP}" ]; then
    echo "=> Create a backup on the startup"
    /backup.sh
fi

# Configure cron
mkdir /etc/cron
echo "${CRON_TIME} /backup.sh >> /mongo_backup.log 2>&1" > /etc/cron/crontab
echo "# empty line" >> /etc/cron/crontab

# Init cron
crontab /etc/cron/crontab

crond -f
