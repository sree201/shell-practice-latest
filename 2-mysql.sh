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


dnf install mysql-selinux.noarch -y &>> $LOGFILE
VALIDATE $? "Installing mysql-selinux.noarch"

systemctl enable mysql-selinux.noarch &>> $LOGFILE
VALIDATE $? "enabling mysql-selinux.noarch"

systemctl start mysql-selinux.noarch &>> $LOGFILE
VALIDATE $? "starting mysql-selinux.noarch"

mysql-secure-installation --set-root-pass ExpenseApp@1  &>> $LOGFILE
VALIDATE $? "Setting up root password"
