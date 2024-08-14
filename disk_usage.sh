#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
DISK_TRE=75%

while IFS= read -r line
do
    USAGE=$(echo $line | awk -F " " '{print $6F}' | cut -d "%" -f1)
    FOLDER=$(echo $line | awk -F " " '{print $NF}')
    if [ $USAGE -ge $DISK_TRE ]
    then
        echo "$FOLDER is more $DISK_TRE current usage: $USAGE"
    fi

done <<< $DISK_USAGE