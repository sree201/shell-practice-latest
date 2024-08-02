#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"

# Validation function
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2...FAILURE"
        exit 1
    else
        echo "$2...SUCCESS"
    fi

}

# Check if super user or not 
if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1
else
    echo "you are a super user."
fi

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Install nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enable nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE

#check your repo and path
cp /home/ec2-user/shell-practice-latest/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restart nginx"