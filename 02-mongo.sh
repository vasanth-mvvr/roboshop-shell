#!/bin/bash

source ./common.sh
check_root

cp /home/ec2-user/roboshop-shell/configurations/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org -y

systemctl enable mongod

systemctl start mongod

# Need to change the localhost application ip to another server 127.0.0.1 t0 0.0.0.0
# vim /etc/mongod.conf
# Restart --> systemctl restart mongod