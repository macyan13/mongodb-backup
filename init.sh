#!/bin/bash

BACKUP_CMD="mongodump --out /backup/"'${BACKUP_NAME}'" --host=${MONGO_HOST} --port=${MONGO_PORT} --username=${MONGO_USERNAME} --password=${MONGO_PASSWD} --authenticationDatabase=admin --db=${MONGO_DB} ${EXTRA_OPTS}"

echo "=> Creating backup script"
rm -f /backup.sh
cat <<EOF >> /backup.sh
#!/bin/bash
MAX_BACKUPS=${MAX_BACKUPS}
BACKUP_NAME=\$(date +\%Y.\%m.\%d.\%H\%M\%S)

echo "=> Backup started"
if ${BACKUP_CMD} ;then
    echo "   Backup succeeded"
else
    echo "   Backup failed"
    rm -rf /backup/\${BACKUP_NAME}
fi

if [ -n "\${MAX_BACKUPS}" ]; then
    while [ \$(ls /backup -N1 | wc -l) -gt \${MAX_BACKUPS} ];
    do
        BACKUP_TO_BE_DELETED=\$(ls /backup -N1 | sort | head -n 1)
        echo "   Deleting backup \${BACKUP_TO_BE_DELETED}"
        rm -rf /backup/\${BACKUP_TO_BE_DELETED}
    done
fi
echo "=> Backup done"
EOF
chmod +x /backup.sh

echo "=> Creating restore script"
rm -f /restore.sh
cat <<EOF >> /restore.sh
#!/bin/bash
echo "=> Restore database from \$1"
if mongorestore --host ${MONGO_DB} --port ${MONGO_PORT} ${USER_STR}${PASS_STR} ${EXTRA_OPTS_RESTORE} \$1; then
    echo "   Restore succeeded"
else
    echo "   Restore failed"
fi
echo "=> Done"
EOF
chmod +x /restore.sh

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
