#!/bin/bash
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
CREDS=$(pwmake 4)
FILE=/home/ec2-user/.ssh/.../delete_me.txt
DATESTAMP=$(date +"%s")

wget -O /etc/motd https://raw.githubusercontent.com/cronflakes/crispy-octo-guacamole/main/motd
update-motd --disable

adduser tieradmin
usermod -aG wheel tieradmin
echo $CREDS | passwd --stdin tieradmin

if [[ ! -f $FILE ]]; then
        mkdir /home/ec2-user/.ssh/...
        fallocate -l 6G $FILE
fi

aws dynamodb put-item --table-name linux-challenge --item '{"password": {"S":"'"$CREDS"'"}, "date": {"S":"'"$DATESTAMP"'"}}' --region us-east-1
echo "sh aws ec2 terminate-instances --instance-ids '"$INSTANCE_ID"'" | at 'now + 30 minutes'

sleep 1
rm -- "$0" 
