#!/bin/bash

source ./common.sh
check_root

echo "Please enter password"
read -s mysql_password


dnf install mysql-server -y &>>$LOG_FILE

systemctl enable mysql &>>$LOG_FILE

systemctl start mysql &>>$LOG_FILE

mysql -h mysql.vasanthreddy.space -u root --p${mysql_password} -e 'show databases'; &>>$LOG_FILE

if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_password} &>>$LOG_FILE
else
    echo -e "The password is already set $Y skipping $N"  
fi

