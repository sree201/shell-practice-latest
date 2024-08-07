#!/bin/bash

SOURCE_DIRECTORY=/tmp/app.log

if [ -d $SOURCE_DIRECTORY ]
then
    echo -e "Source directory exists"
else
    echo "Please make sure $SOURCE_DIRECTORY exists"
fi

FILE=$(find $SOURCE_DIRECTORY -name "*.log" -mtime +14 )

while IFS= read -r line
do
    echo "Deleting file: $line"
    rm -rf $line
done <<< input