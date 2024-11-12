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

variable "vpc_id" {
  description = "ID of the VPC to associate the DB with"
  type        = string
}

variable "subnet_ids" {
  description = "List of the subnet IDs where to deploy the DB"
  type        = list(string)
}

variable "rsg_ids" {
  description = "Allow connection to the db to instances in this security group"
  type        = list(string)
}

variable "db_version" {
  description = "Version of the DB engine to use in the RDS. Default is '8.0.35'"
  type        = string
  default     = "8.0.35"
}

variable "instance_class" {
  description = "Instance class to deploy. Default is 'db.t3.micro'"
  type        = string
  default     = "db.t3.micro"
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

variable "sg_ids" {
  description = "List of the security groups IDs to associate with the DB. Default is []"
  type        = list(string)
  default     = []
}

variable "allocated_storage" {
  description = "Size of DB instance to allocate. Default is '20'"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "The maximum DB instance size that can be. Default is '60'"
  type        = number
  default     = 60
}

variable "snapshot_identifier" {
  description = "Id of the provisioned DB snapshot"
  type        = string
}