#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 $1 $2"
    exit 1
fi

# Assign input arguments to variables
SOURCE_DIR="$1"
DESTINATION_DIR="$2"

# Validate source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# Validate destination directory
if [ ! -d "$DESTINATION_DIR" ]; then
    echo "Error: Destination directory $DESTINATION_DIR does not exist."
    exit 1
fi

# Create a timestamp
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# Define the archive filename with timestamp
ARCHIVE_NAME=$(basename "$SOURCE_DIR")_"$TIMESTAMP".tar.gz
ARCHIVE_PATH="$DESTINATION_DIR/$ARCHIVE_NAME"

# Create the compressed archive
echo "Creating backup of $SOURCE_DIR as $ARCHIVE_PATH"
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# Check if the archive was created successfully
if [ $? -eq 0 ]; then
    echo "Backup successfully created at $ARCHIVE_PATH"
else
    echo "Error: Failed to create backup."
    exit 1
fi