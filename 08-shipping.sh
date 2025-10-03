#!/bin/bash

source ./common.sh
check_root

dnf install maven -y &>>$LOG_FILE

if id roboshop &>>$LOG_FILE;
then 
    echo "User exists $Y Skipping $N"
else
    useradd roboshop &>>$LOG_FILE
fi

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOG_FILE

mkdir -p /app &>>$LOG_FILE
cd /app &>>$LOG_FILE
rm -rf /app/* &>>$LOG_FILE
unzip /tmp/shipping.zip &>>$LOG_FILE
mvn clean package &>>$LOG_FILE
mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE


mv /home/ec2-user/roboshop-shell/configurations/shipping.service /etc/systemd/system/shipping.service  &>>$LOG_FILE

systemctl daemon-reload  &>>$LOG_FILE

systemctl enable shipping  &>>$LOG_FILE

systemctl start shipping  &>>$LOG_FILE

dnf install mysql -y  &>>$LOG_FILE

mysql -h mysql.vasanthreddy.space < /app/db/schema.sql  &>>$LOG_FILE

mysql -h mysql.vasanthreddy.space < /app/db/app-user.sql  &>>$LOG_FILE

mysql -h mysql.vasanthreddy.space < /app/db/master-data.sql  &>>$LOG_FILE

systemctl restart shipping  &>>$LOG_FILE



