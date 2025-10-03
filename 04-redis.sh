#!/bin/bash

source ./common.sh
check_root

dnf install redis -y &>>$LOG_FILE
 
#Usually the port is localhost which is accessed by the application so in our case we want access it from the another server so we need to change it to 0.0.0.0.
#vim /etc/redis/redis.conf
sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$LOG_FILE
systemctl enable redis &>>$LOG_FILE
systemctl start redis &>>$LOG_FILE

