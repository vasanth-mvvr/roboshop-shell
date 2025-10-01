#!/bin/bash

source ./common.sh
check_root

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing nginx" 

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "enabling nginx" 

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Running nginx" 

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOG_FILE
VALIDATE $? "Downloading application code"

cd /usr/share/nginx/html &>>$LOG_FILE
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
unzip /tmp/web.zip &>>$LOG_FILE
VALIDATE $? "Removing the default content and extracting the application code" 


cp /home/ec2-user/roboshop-shell/configurations/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
VALIDATE $? "changing the directory" 

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "Restarted the service"



