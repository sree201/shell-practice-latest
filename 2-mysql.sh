#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPTNAME.log

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2...FAILURE"
        exit 1
    else
        echo "$2...SUCCESS"
    fi

}

if [ $USERID -ne 0 ]
then
    echo "Please run this with root user access"
    exit 1
else
    echo "your are a super user"
fi


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql-server"

systemctl enable mysqld.service &>>$LOGFILE
VALIDATE $? "enabling mysqld.service"

systemctl start mysqld.service &>>$LOGFILE
VALIDATE $? "starting mysqld.service"

#mysql-secure-installation --set-root-pass ExpenseApp@1  &>>$LOGFILE

mysql -h 172.31.89.71 -uroot -PExpenseApp@1 -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1  &>>$LOGFILE
else
    echo -e "mysql root password is already setup...SKIPPING"
fi

