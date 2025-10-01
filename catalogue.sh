#!/bin/bash
# **Catalogue**

source ./common.sh
check_root


dnf module list nodejs &>>$LOG_FILE

dnf module disable nodejs -y &>>$LOG_FILE

dnf module enable nodejs:20 -y &>>$LOG_FILE

dnf install nodejs -y &>>$LOG_FILE

id=roboshop &>>$LOG_FILE
if [ $id -ne 0 ]
then 
    useradd roboshop &>>$LOG_FILE
else
    echo -e "The user is present $Y Skipping $N"
fi 

mkdir -p /app &>>$LOG_FILE   # -p --> present

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOG_FILE

cd /app &>>$LOG_FILE
rm -rf /app/* &>>$LOG_FILE
unzip /tmp/catalogue.zip &>>$LOG_FILE

npm install &>>$LOG_FILE

cp /home/ec2-user/roboshop-shell/configurations/catalogue.service /etc/systemd/system/catalogue.service &>>$LOG_FILE 

systemctl daemon-reload &>>$LOG_FILE 

systemctl enable catalogue &>>$LOG_FILE 

systemctl start catalogue &>>$LOG_FILE 

cp /home/ec2-user/roboshop-shell/configurations/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE

dnf install mongodb-mongosh -y &>>$LOG_FILE

mongosh --host mongo.vasanthreddy.space </app/schema/catalogue.js &>>$LOG_FILE

systemctl restart catalogue &>>$LOG_FILE

