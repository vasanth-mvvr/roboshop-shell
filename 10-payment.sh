#!/bin/bash

source ./common.sh
check_root

dnf install python3.11 gcc python3-devel -y  &>>$LOG_FILE

if id roboshop &>>$LOG_FILE;
then 
    echo "User already exists $Y skipping"
else
    useradd roboshop  &>>$LOG_FILE
fi 


curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip  &>>$LOG_FILE

mkdir -p /app  &>>$LOG_FILE
rm -rf /app/*  &>>$LOG_FILE
cd /app  &>>$LOG_FILE
unzip /tmp/payment.zip  &>>$LOG_FILE
pip3.11 install -r requirements.txt  &>>$LOG_FILE

vim /home/ec2-user/roboshop-shell/configurations/payment.service /etc/systemd/system/payement.service  &>>$LOG_FILE

systemctl daemon-reload  &>>$LOG_FILE
 
systemctl enable payment  &>>$LOG_FILE

systemctl start payment  &>>$LOG_FILE



