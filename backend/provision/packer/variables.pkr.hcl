variable "region" {
  type    = string
  default = "us-east-2"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "credentials_file" {
  type    = string
  default = "~/.aws/credentials"
}

variable "pkey" {
  type    = string
  default = "ssh-pub-key"
}

variable "db_endpoint" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "iam_profile" {
  type = string
}

variable "db_port" {
  type = number
}

variable "subnet_id" {
  type = string
}