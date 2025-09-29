######################
#
# Author: Karan
# Date: 29th-Sep
#
# Version: v1
#
# This script will report the AWS resource usage
######################

# debug mode
set -x

# list S3 buckets
aws s3 ls

# list EC2 Instances
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]" \
  --output table

# list Lambda functions
aws lambda list-functions --query "Functions[*].[FunctionName,Runtime]" --output table

# list IAM users
aws iam list-users --query "Users[*].[UserName,UserId]" --output table
