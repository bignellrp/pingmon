#!/bin/bash

WEBHOOK='https://hooks.slack.com/services/YOURWEBHOOKCODEHERE'
NODES='/boot/config/plugins/user.scripts/scripts/pingmon/pingmon_nodes'
LOG='/var/log/syslog'
DATEFORMAT=`date '+%b %d %T'`

while read LINE; do
    NAME=$(echo $LINE|awk -F "," '{print ($1)}')
    IP=$(echo $LINE|awk -F "," '{print ($2)}')
    if ping -c 3 $IP &> /dev/null; then
        echo "$DATEFORMAT $HOSTNAME pingmon: $NAME Ping is ok!" >> $LOG
    else
        curl -X POST -H 'Content-type: application/json' --data '{"text": "'"${NAME} is down!"'"}' $WEBHOOK
        echo "$DATEFORMAT $HOSTNAME pingmon: $NAME Ping is down!" >> $LOG
    fi
done < $NODES
