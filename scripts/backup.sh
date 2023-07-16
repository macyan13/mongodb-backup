#!/bin/bash

MAX_BACKUPS=${MAX_BACKUPS}
BACKUP_NAME=$(date +%d.%m.%Y:%m.%H-%M-%S)

echo "=> ${BACKUP_NAME} -  Backup started"
if mongodump --archive=/backup/"${BACKUP_NAME}".gz --gzip --host="${MONGO_HOST}" --port="${MONGO_PORT}" --username="${MONGO_USERNAME}" --password="${MONGO_PASSWD}" --authenticationDatabase=admin --db="${MONGO_DB}" "${EXTRA_OPTS}" ;then
    echo "   Backup succeeded"
else
    echo "   Backup failed"
    rm -rf /backup/"${BACKUP_NAME}"
fi

if [ -n "${MAX_BACKUPS}" ]; then
    while [ "$(ls -t /backup | wc -l)" -gt ${MAX_BACKUPS} ]; do
        BACKUP_TO_BE_DELETED="$(ls -t /backup | tail -n 1)"
        echo "   Deleting backup ${BACKUP_TO_BE_DELETED}"
        rm -rf /backup/"${BACKUP_TO_BE_DELETED}"
    done
fi
echo "=> Backup done"