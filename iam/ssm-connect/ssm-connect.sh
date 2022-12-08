#!/bin/bash
#must have VPC endpoint in private subnet 

ROLE_NAME="ssm-role"
POLICY_DOC="/home/$USER/assume-role-policy.json"
INST_PROFILE_NAME="ssm-ec2-instance-profile"
TARGET_INST_ID="i-033f9708b21a4ae1f"

#get policy doc
wget -O $POLICY_DOC https://raw.githubusercontent.com/cronflakes/crispy-octo-guacamole/main/iam/assume-role-policy.json

#create IAM role
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://$POLICY_DOC

#attach AmazonSSMManagedInstanceCore policy
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore

#create ec2 instance profile
aws iam create-instance-profile --instance-profile-name $INST_PROFILE_NAME

#attach the IAM role to instance profile
aws iam add-role-to-instance-profile --role-name $ROLE_NAME --instance-profile-name $INST_PROFILE_NAME

#aws ssm start-session
aws ssm start-session --target $TARGET_INST_ID
