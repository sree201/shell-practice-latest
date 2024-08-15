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

echo "$MESSAGE" | mail -s "Disk usage alert" koyisrinath@gmail.com

# echo "body" | mail -s "Subject" to-address


# # Configuration
# THRESHOLD=1024           # Threshold in MB (e.g., 1024 MB = 1 GB)
# AVAILABLE_RAM=$(free -m | awk -F " " '{print $7F}')
# MESSAGE=""

# while IFS=read -r line
# do
#     USAGE=$(echo $line | awk '/^Mem:/{print $7}' | cut -d "GB" -f1)
#     FOLDER=$(echo $line | awk '/^Mem:/{print $NF}')
#     if [ $USAGE -ge $THRESHOLD ]
#     then
#         MESSAGE+="$FOLDER is more than $TRESHOLD,  current usage: $USAGE"
#     fi

# done <<< "$AVAILABLE_RAM"

# echo -e "MESSAGE: $MESSAGE"

# echo "$MESSAGE" | mail -s "Available ram usage alert" koyisrinath@gmail.com


    
