#!/bin/bash
dnf module disable nodejs -y &>>$LOG_FILE

dnf module enalbe nodejs:20 -y &>>$LOG_FILE

dnf install nodejs -y &>>$LOG_FILE

if id roboshop &>>$LOG_FILE;
then 
    echo "user already exists $Y Skipping $N "
else
    useradd roboshop &>>$LOG_FILE
fi

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOG_FILE

mkdir -p app &>>$LOG_FILE
cd /app &>>$LOG_FILE
rm -rf /app/* &>>$LOG_FILE
unzip /tmp/cart.zip &>>$LOG_FILE
npm install &>>$LOG_FILE

cp /home/ec2-user/roboshop-shell/configurations/cart.service /etc/systemd/system/cart.service &>>$LOG_FILE

systemctl daemon-reload &>>$LOG_FILE

systemctl enable cart &>>$LOG_FILE

systemctl start cart &>>$LOG_FILE
