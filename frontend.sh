sourse ./common.sh

check_root

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
VALIDATE $? "Expense user Copy"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restart nginx"