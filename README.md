# Description

Project for deploying [VProfile](https://github.com/hkhcoder/vprofile-project) project using AWS services for hosting, Packer for provisioning DataBase, and Terraform for Infrastructure as Code (IaC)

# Infrastructure

## Backend
 - VPC with 2 public and 2 private subnets
 - RDS service in the private subnets
 - Elastic Cache service in the private subnet
 - MQ Broker service in the private subnet
## Frontend
 - Beanstalk in the public subnets, which contains:
    - EC2 instance for hosting Tomcat web application
    - Autoscaling group
    - Elastic loadbalancer
 - S3 Bucket for storing web application artifact
 - Cloudfront for CDN

# Other resources

- SNS service for sending notifications via email

# WARNING!!!

Snapshot after provision DataBase must be removed manully.
