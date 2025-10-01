#!/bin/bash


dnf install redis -y &>>$LOG_FILE
 
#Usually the port is localhost which is accessed by the application so in our case we want access it from the another server so we need to change it to 0.0.0.0.
#vim /etc/redis/redis.conf

systemctl enable redis &>>$LOG_FILE
systemctl start redis &>>$LOG_FILE

