#!/bin/bash

#instances=("mongodb" "redis" "catalouge" "cart" "user" "web" "shipping" "mysql" "rabbitmq" "payment")
instances=("shipping" "web")
hosted_zone_id="Z02340692WDUGXG2FUTDA"
domain_name="vasanthreddy.space"

for name in ${instances[@]};
do 
    if [ $name == "shipping" ] || [ $name=="mysql" ]
    then 
        instance_type="t3.medium"
    else
        instance_type="t2.micro"
    fi
    echo "The instances are : $name and the instance type is : $instance_type"   
    instance_id=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type $instance_type  --security-group-ids sg-0aaab2bdfa4e9f45a --subnet-id subnet-0d91ae6100b003216 --query 'Instances[0].InstanceId' --output text)


    aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$name

    if [ $name == "web" ]
    then 
        aws ec2 wait instance-running --instance-ids $instance_id
        public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].PublicIpAddress' --output text) 
        ip_to_use=$public_ip
    else
        private_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
        ip_to_use=$private_ip
    fi
    aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$name.$domain_name'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$ip_to_use'"
            }]
        }
        }]
    }'

done
