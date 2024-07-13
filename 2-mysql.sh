#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPTNAME.log

VALDIATE=$(){
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
    echo "Please run this script with root access"
    exit 1
else
    echo "Your are a super user"
fi

dnf install mysql-selinux.noarch -y &>> $LOGFILE
VALIDATE $? "Installing mysql-selinux.noarch"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "enabling mysqld"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "starting mysqld"

mysql-secure-installation --set-root-pass ExpenseApp@1  &>> $LOGFILE
VALIDATE $? "Setting up root password"
