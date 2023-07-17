# mongodb-backup

Helper image to create mongodb archived backups via mongodump using cronjob to `/backup` folder. Can restore dumps running mongorestore.

## Usage:

    docker run -d \
        --env MONGO_HOST=mongodb.host \
        --env MONGO_PORT=27017 \
        --env MONGO_USERNAME=admin \
        --env MONGO_PASSWD=password \
        --env MONGO_DB=mongodb.db \
        --volume host.folder:/backup
        macyan/mongodb-backup

## Parameters

    MONGO_HOST             the host/ip of your mongodb database
    MONGO_PORT             the port number of your mongodb database
    MONGO_USERNAME         the username of your mongodb database
    MONGO_PASSWD           the password of your mongodb database
    MONGO_DB               the database name to dump. If not specified, it will dump all the databases
    EXTRA_OPTS             the extra options to pass to mongodump command
    EXTRA_OPTS_RESTORE     the extra options to pass to mongorestore command
    CRON_TIME              the interval of cron job to run mongodump. `0 0 * * *` by default, which is every day at 00:00
    MAX_BACKUPS            the number of backups to keep. When reaching the limit, the old backup will be discarded. No limit, by default

## Restore from a backup

See the list of backups, you can run:

    docker exec mongodb-backupp ls /backup

To restore database from a certain backup, simply run:

    docker exec mongodb-backup /restore.sh /backup/16.07.2023:07.21-35-00.gz

## Example of using in docker compose

    services:
        mongodb-backup:
            image: macyan13/mongodb-backup:latest
            container_name: "mongodb-backup"
            restart: always
            depends_on:
              - mongo
            environment:
            - MONGO_HOST
              - MONGO_PORT
              - MONGO_USERNAME
              - MONGO_PASSWD
              - MONGO_DB
              - MONGO_BACKUP_CRON_TIME=*/5 * * * *
              - MONGO_BACKUP_MAX_BACKUPS=10
              - EXTRA_OPTS
              - EXTRA_OPTS_RESTORE
          volumes:
            - ./backup:/backup

Crontab output goes to standard docker logs