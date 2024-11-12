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

variable "engine" {
  description = "DB engine will be used in the RDS. Default is 'mysql'"
  type        = string
  default     = "mysql"
}

variable "db_version" {
  description = "Version of the DB engine to use in the RDS. Default is '8.0.35'"
  type        = string
  default     = "8.0.35"
}

variable "instance_class" {
  description = "Instance class to deploy. Default is 'db.t3.micro'"
  type        = string
  default     = "db.t4g.micro"
}

variable "username" {
  description = "Username will be used for connecting to the DB."
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "port" {
  description = "Port number will be use for connecting to the DB. Default is '3306'"
  type        = number
  default     = 3306
}

variable "family" {
  description = "Parameter group family. Default is 'mysql8.0'"
  type        = string
  default     = "mysql8.0"
}

variable "db_name" {
  description = "The name of the DB that will be created during initialization. Default is 'accounts'"
  type        = string
  default     = "accounts"
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}