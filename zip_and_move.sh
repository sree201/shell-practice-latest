#!/bin/bash

# Define source and destination directories
SOURCE_DIR="/path/to/source_directory"
DESTINATION_DIR="/path/to/destination_directory"

# Define the name of the zip file
ZIP_FILE_NAME="archived_files.zip"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]
then
    echo "Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# Create the zip file from the source directory
echo "Zipping files from $SOURCE_DIR..."
zip -r "$ZIP_FILE_NAME" "$SOURCE_DIR" > /dev/null

# Check if the zip command was successful
if [ $? -ne 0 ]
then
    echo "Failed to create zip file."
    exit 1
fi

# Move the zip file to the destination directory
echo "Moving zip file to $DESTINATION_DIR..."
mv "$ZIP_FILE_NAME" "$DESTINATION_DIR"

# Check if the move command was successful
if [ $? -ne 0 ]
then
    echo "Failed to move zip file to destination."
    exit 1
fi

echo "Operation completed successfully."
