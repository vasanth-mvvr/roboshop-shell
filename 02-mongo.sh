#!/bin/bash

source ./common.sh
check_root

cp /home/ec2-user/roboshop-shell/configurations/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE

dnf install mongodb-org -y &>>$LOG_FILE

systemctl enable mongod &>>$LOG_FILE

systemctl start mongod &>>$LOG_FILE

# Need to change the localhost application ip to another server 127.0.0.1 t0 0.0.0.0
# vim /etc/mongod.conf
sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG_FILE

systemctl restart mongod &>>$LOG_FILE