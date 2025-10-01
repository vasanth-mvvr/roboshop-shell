#!/bin/bash

dnf module disable nodejs -y &>>$LOG_FILE

dnf module enalbe nodejs:20 -y &>>$LOG_FILE

dnf install nodejs -y &>>$LOG_FILE
if id roboshop &>>$LOG_FILE;
then 
    echo "$Y The user exists skipping ... $N"
else
    useradd roboshop &>>$LOG_FILE
fi

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

mkdir -p /app &>>$LOG_FILE
cd /app &>>$LOG_FILE
rm -rf /app/* &>>$LOG_FILE
unzip /tmp/user.zip &>>$LOG_FILE
npm install &>>$LOG_FILE

cp /home/ec2-user/roboshop-shell/configurations/user.service /etc/systemd/system/user.service &>>$LOG_FILE

systemctl daemon-reload &>>$LOG_FILE


systemctl enable user &>>$LOG_FILE

systemctl start user &>>$LOG_FILE

cp /home/ec2-user/roboshop-shell/configurations/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE

dnf install mongodb-mongosh -y &>>$LOG_FILE

mongosh --host mongo.vasanthreddy.space </app/schema/user.js

