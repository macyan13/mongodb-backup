#!/bin/bash
echo "=> Restore database from \$1"
if mongorestore --host="${MONGO_HOST}" --port="${MONGO_PORT}" --username="${MONGO_USERNAME}" --password="${MONGO_PASSWD}" --authenticationDatabase=admin --db="${MONGO_DB}" "${EXTRA_OPTS}" "${EXTRA_OPTS_RESTORE}" "$1"; then
    echo "   Restore succeeded"
else
    echo "   Restore failed"
fi
echo "=> Done"