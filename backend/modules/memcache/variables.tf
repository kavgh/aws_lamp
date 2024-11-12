variable "project" {
  description = "Name of the project. Default is 'project'"
  type        = string
  default     = "project"
}

variable "env" {
  description = "Environment to deploy. Default is 'env'"
  type        = string
  default     = "env"
}

variable "tags" {
  description = "The tags to attach to the RDS. Default is '{}'"
  type        = map(string)
  default     = {}
}

variable "sns_arn" {
  description = "ARN of the SNS topic where to send notifications. Default is 'null'"
  type        = string
  default     = null
}

variable "sg_ids" {
  description = "List of the security group IDs to associate with. Default is '[]'"
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "Name of the engine to create elasticache instance. Default is 'memcached'"
  type        = string
  default     = "memcached"
}

variable "port" {
  description = "Port number of the elasticache instance. Default is '11211'"
  type        = number
  default     = 11211
}

variable "vpc_id" {
  description = "ID of the VPC to associate with"
  type        = string
}

variable "rsg_ids" {
  description = "Allow connection to the elasticache instance to instances from this security group"
  type        = list(string)
}

variable "family" {
  description = "The family of the parameter group corresponding to the engine version. Default is 'memcached1.6'"
  type        = string
  default     = "memcached1.6"
}

variable "subnet_ids" {
  description = "The list of subnet IDs to associate with subnet group"
  type        = list(string)
}