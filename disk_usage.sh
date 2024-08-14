#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
DISK_TRESHOLD=6
MESSAGE=""

while IFS= read -r line
do
    USAGE=$(echo $line | awk -F " " '{print $6F}' | cut -d "%" -f1 )
    FOLDER=$(echo $line | awk -F " " '{print $NF}' )
    if [ $USAGE -ge $DISK_TRESHOLD ]
    then
        MESSAGE+="$FOLDER is more than $DISK_TRESHOLD,  Current usage: $USAGE"
    fi

done <<< $DISK_USAGE

echo -e "MESSAGE: $MESSAGE"