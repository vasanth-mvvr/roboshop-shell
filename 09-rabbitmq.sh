#!/bin/bash

source ./common.sh
check_root

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE

 curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG_FILE

dnf install rabbitmq-server -y &>>$LOG_FILE

systemctl enable rabbitmq-server &>>$LOG_FILE

systemctl start rabbitmq-server &>>$LOG_FILE

sudo rabbitmqctl list_users | grep roboshop
if [ $? -ne 0 ]
then 
    rabbitmqctl add_user roboshop roboshop123
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
else
    echo "The user exists $Y skipping $N"
fi



