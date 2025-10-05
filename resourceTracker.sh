#!/bin/bash
# ===============================================================
#
# Author: Karan
# Date: 29th-Sep
#
# Version: v1
#
# This script lists key AWS resources in your account:
#   - S3 Buckets
#   - EC2 Instances
#   - Lambda Functions
#   - IAM Users
# The script also uses AWS CLI's query filters and table output
# to make the results readable for Us.
# ===============================================================

# Enable debug mode so each command is printed before execution.
# Helpful for troubleshooting and understanding command flow.
set -x

# ---------------------------------------------------------------
# List all S3 Buckets
# ---------------------------------------------------------------
# 'aws s3 ls' lists every S3 bucket in your AWS account along with
# the creation date. Simple and straightforward — no filters needed.
aws s3 ls

# ---------------------------------------------------------------
# List all EC2 Instances (with filtered details)
# ---------------------------------------------------------------
# 'aws ec2 describe-instances' gives a large JSON response that
# contains detailed information about every EC2 instance.
# The '--query' option filters and extracts only specific fields
# using JMESPath syntax.
#
# QUERY EXPLAINED:
#   Reservations[*]        → Go through each reservation group.
#   .Instances[*]          → Inside each reservation, go through each instance.
#   .[InstanceId,State.Name,PublicIpAddress]
#                          → For each instance, extract these three fields:
#                             1. InstanceId      → unique ID of the EC2 instance
#                             2. State.Name      → current state (running/stopped)
#                             3. PublicIpAddress → public IP if assigned
#
# The '--output table' flag formats the result into a clean table
# instead of raw JSON, making it much easier to read.
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]" \
  --output table

# ---------------------------------------------------------------
# List all Lambda Functions
# ---------------------------------------------------------------
# 'aws lambda list-functions' fetches all AWS Lambda functions
# in your account.
# The '--query' part filters out only:
#   - FunctionName → name of the function
#   - Runtime      → the language/runtime it uses (e.g., nodejs, python)
#
# '--output table' again makes the result look clean.
aws lambda list-functions \
  --query "Functions[*].[FunctionName,Runtime]" \
  --output table

# ---------------------------------------------------------------
# List all IAM Users
# ---------------------------------------------------------------
# 'aws iam list-users' lists every IAM user in your AWS account.
# The '--query' part picks only:
#   - UserName → login/user name
#   - UserId   → internal AWS user ID
#
# The '--output table' flag displays the output in an easy-to-read format.
aws iam list-users \
  --query "Users[*].[UserName,UserId]" \
  --output table

# ===============================================================
# END OF SCRIPT
# ---------------------------------------------------------------
# QUICK SUMMARY:
#   - 'set -x' → enables debug mode (shows commands as they run)
#   - '--query' → filters JSON data to show only what you need
#   - '--output table' → makes output readable
#   - '\' → allows multi-line commands for readability
#
# This script is great for quick AWS resource tracking and auditing.
# ===============================================================

