#!/bin/bash

CREDS=$(pwmake 4)
FILE=/home/ec2-user/.ssh/.../delete_me.txt

if [[ ! -f $FILE ]]; then
        fallocate -l 6G /home/ec2-user/.ssh/.../delete_me.txt
fi

aws dynamodb put-item --table-name linux-challenge --item '{"password": {"S":"'"$CREDS"'"}}' --region us-east-1
echo $CREDS | passwd --stdin tieradmin
