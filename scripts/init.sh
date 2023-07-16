#!/bin/bash

# Configure cron
mkdir /etc/cron
echo "${CRON_TIME} /backup.sh >> /dev/stdout" > /etc/cron/crontab
echo "# empty line" >> /etc/cron/crontab

# Init cron
crontab /etc/cron/crontab
crond -f
