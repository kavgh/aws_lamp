variable "project" {
  description = "The project name. Default is 'project'"
  type        = string
  default     = "project"
}

variable "env" {
  description = "Environment where to deploy. Default is 'env'"
  type        = string
  default     = "env"
}

variable "tags" {
  description = "Map of the tags to associate with the instance. Default is '{}'"
  type        = map(string)
  default     = {}
}

variable "engine" {
  description = "The engine type to deploy. Default is 'RabbitMQ'"
  type        = string
  default     = "RabbitMQ"
}

variable "engine_version" {
  description = "The version of the engine to deploy. Default is '3.13'"
  type        = string
  default     = "3.13"
}

variable "instance_type" {
  description = "The instance type to deploy. Default is 'mq.t3.micro'"
  type        = string
  default     = "mq.t3.micro"
}

variable "sg_ids" {
  description = "Addtitional list of the security group IDs to associate with. Default is '[]'"
  type        = list(string)
  default     = []
}

variable "username" {
  description = "The username to access broker. Default is 'rabbit'"
  type        = string
  default     = "rabbit"
}

variable "subnet_ids" {
  description = "The IDs of the subnet where to deploy broker"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with"
  type        = string
}

variable "rsg_ids" {
  description = "The iD of the security group members from which will be allowed ingress traffic"
  type        = list(string)
}