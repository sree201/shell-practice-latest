USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"

echo "Please enter DB Password:"
read -s mysql_root_password

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
    echo "Please run this script with root access."
    exit 1
else
    echo "you are a super user."
fi

dnf install mysql-server -y &>> $LOGFILE
VALIDATE $? "Installing Mysql Server"

systemctl enable mysqld.service &>> $LOGFILE
VALIDATE $? "Enabling Mysql server"

systemctl start mysqld.service &>> $LOGFILE
VALIDATE $? "Starting Mysql server"

#mysql_secure_installation --set-root-password ExpenseApp@1 &>> $LOGFILE
#VALIDATE $? "Settting up root password"

mysql -h techitcloud.online -uroot -p${mysql_root_password} -e 'show databases;' &>> $LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>> $LOGFILE
    VALIDATE $? "MySQL root password setup"
else
    echo "MySQL root password is already setup...$Y SKIPPING $N"
fi

