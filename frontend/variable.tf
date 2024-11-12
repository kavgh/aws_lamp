variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs"
  type        = list(string)
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "ec2_sg_ids" {
  description = "List of the security group to associate with EC2 instances"
  type        = list(string)
}

#variable "elb_sg_ids" {
#  type = list(string)
#}