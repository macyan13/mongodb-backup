FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add --no-cache bash
RUN apk add --no-cache mongodb-tools

ENV CRON_TIME="0 0 * * *"

ADD scripts/init.sh /init.sh
RUN chmod +x /init.sh

ADD scripts/backup.sh /backup.sh
RUN chmod +x /backup.sh

ADD scripts/restore.sh /restore.sh
RUN chmod +x /restore.sh

VOLUME ["/backup"]
CMD ["/init.sh"]