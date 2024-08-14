#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
DISK_TRESHOLD=75%

while IFS= read -r line
do
    USAGE=$(echo $line | awk -F " " '{print $6F}' | cut -d "%" -f1)
    FOLDER=$(echo $line | awk -F " " '{print $NF}')
    if [ $USAGE -ge $DISK_TRESHOLD ]
    then
        echo "$FOLDER is more $DISK_TRESHOLD current usage: $USAGE"
    fi

done <<< $DISK_USAGE