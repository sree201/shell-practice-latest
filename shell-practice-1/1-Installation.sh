#!/bin/bash
#"Shibang is the location of shell interpretter so it will read the commands and execute the commands "

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo $2..."FAILURE"
        exit 1
    else
        echo $2..."SUCCESS"
    fi
}

if [ $USERID -ne 0 ]
    then
        echo "Please run this script with root access."
        exit 1 #manually exit if error comes
    else
        echo "your are a super user"
    fi

dnf install mysql -y $>>$LOGFILE
VALIDATE $? "Installing MySQL"

dnf install mysql-selinux.noarch -y $>>$LOGFILE

dnf install git -y $>>$LOGFILE
VALIDATE $? "Installing Git"

echo "is script processing"


# cat 01-Delete_Archive_logs.sh
# #!/bin/bash

# R="\e[31m"
# G="\e[32m"

# Set the directory path where log files are located
# log_directory="/var/log/"

# Set the threshold age for log files
# threshold_days=14

# delete old log files
# delete_old_logs() {
# find "$log_directory" -type f -name ".2023" -mtime +"$threshold_days" -exec rm {} ;
# echo "Old log files $R deleted."
# }

# Function to archive old log files
# archive_old_logs() {
# archive_name="log_archive_$(date +'%Y%m%d').tar.gz"
# find "$log_directory" -type f -name ".2023" -mtime +"$threshold_days" -exec tar -czvf "$archive_name" {} +
# echo "Old log files $G archived to $archive_name."
# }
