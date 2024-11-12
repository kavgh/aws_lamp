variable "project" {
  description = "The name of the project. Default is 'project'"
  type        = string
  default     = "project"
}

variable "env" {
  description = "The name of the environment where to deploy project. Default is 'env'"
  type        = string
  default     = "env"
}

variable "tags" {
  description = "The map of tags to associate with. Default is '{}'"
  type        = map(string)
  default     = {}
}

variable "tier" {
  description = "Environment tier to use. It has to possible values 'WebServer' and 'Worker'. Default is 'WebServer'"
  type        = string
  default     = "WebServer"

  validation {
    condition     = can(regex("^(WebServer|Worker)$", var.tier))
    error_message = "The value must be 'WebServer' or 'Worker'"
  }
}

variable "solution_stack_name" {
  description = "The name of a solution stack to base on your environment. Default is '64bit Amazon Linux 2023 v5.3.2 running Tomcat 10 Corretto 21'"
  type        = string
  default     = "64bit Amazon Linux 2023 v5.3.2 running Tomcat 9 Corretto 11"
}

variable "key_pair" {
  description = "The name of the key pair to use to log in EC2 instance"
  type        = string
}

variable "instance_profile_arn" {
  description = "The AEN of the instance profile to associate with"
  type        = string
}

variable "sg_ids" {
  description = "The list of security group IDs to associate with. Default is '[]'"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs to associate with"
  type        = list(string)
}

variable "elb_type" {
  description = "Specifie the type of the load balancer to launch. Possible values are 'classic', 'application', 'network'. Default is 'application'"
  type        = string
  default     = "application"
}

variable "service_role_arn" {
  description = "The ARN of the service role to associate with"
  type        = string
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic to associate with. Default is 'None'"
  type        = string
  default     = ""
}

variable "elb_sg_ids" {
  description = "List of IDs of the security group to associate with load balancer. Default is '[]'"
  type        = list(string)
  default     = []
}

variable "bucket_name" {
  description = "The name of the S3 bucked where the deployment artifacts are stored"
  type        = string
}

variable "artifact_name" {
  description = "The name of the S3 object in the S3 bucket"
  type        = string
}