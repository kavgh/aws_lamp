variable "project" {
  description = "Name of the project. Default is 'project'"
  type        = string
  default     = "project"
}

variable "env" {
  description = "Environment where to deploy VPC. Default is 'env'"
  type        = string
  default     = "env"
}

variable "tags" {
  description = "Tags to associate with. Default is {}"
  type        = map(string)
  default     = {}
}

variable "ipv4_cidr" {
  description = "CIDR block to use in the VPC. Default is '172.16.0.0/16'"
  type        = string
  default     = "172.16.0.0/16"
}