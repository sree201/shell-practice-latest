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

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs:20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating Expense User"
    
else
    echo -e "Expense user already created...$Y SKIPPING $N"
fi


mkdir -p /app

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE

npm install 
npm install -g npm@10.8.2

# check your repo and path
cp /home/ec2-user/shell-practice-latest/4-backend.service /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl start backend &>>$LOGFILE

systemctl enable backend &>>$LOGFILE

dnf install mysql -y &>>$LOGFILE

# mysql -h techitcloud.cloud -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
# VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE

#mysql_secure_installation --set-root-password ExpenseApp@1 &>> $LOGFILE
#VALIDATE $? "Settting up root password"

mysql -h backend.techitcloud.online -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
    VALIDATE $? "MySQL root password setup"
else
    echo "MySQL root password is already setup...$Y SKIPPING $N"
fi





















# #!/bin/bash

# source ./common.sh

# check_root

# echo "Please enter DB password:"
# read -s mysql_root_password

# dnf module disable nodejs -y &>>$LOGFILE
# dnf module enable nodejs:20 -y &>>$LOGFILE
# dnf install nodejs -y &>>$LOGFILE

# id expense &>>$LOGFILE
# if [ $? -ne 0 ]
# then
#     useradd expense &>>$LOGFILE
# else
#     echo -e "Expense user already created...$Y SKIPPING $N"
# fi

# mkdir -p /app &>>$LOGFILE

# curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE

# cd /app
# rm -rf /app/*
# unzip /tmp/backend.zip &>>$LOGFILE

# npm install &>>$LOGFILE

# #check your repo and path
# cp /home/ec2-user/expense-shell-1/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

# systemctl daemon-reload &>>$LOGFILE

# systemctl start backend &>>$LOGFILE

# systemctl enable backend &>>$LOGFILE

# dnf install mysql -y &>>$LOGFILE

# mysql -h db.daws78s.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

# systemctl restart backend &>>$LOGFILE