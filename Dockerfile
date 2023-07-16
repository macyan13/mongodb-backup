FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add --no-cache bash
RUN apk add --no-cache mongodb-tools

ENV CRON_TIME="0 0 * * *"

ADD init.sh /init.sh
RUN chmod +x /init.sh

VOLUME ["/backup"]
CMD ["/init.sh"]