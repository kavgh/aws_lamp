variable "shared_credentials" {
  description = "List of the paths to the credentials files"
  type        = list(string)
  default     = ["~/.aws/credentials"]
}

variable "shared_config" {
  description = "List of the paths to the config files"
  type        = list(string)
  default     = ["~/.aws/config"]
}

variable "profile" {
  description = "The profile name use for deploying"
  type        = string
  default     = "default"
}

variable "email" {
  description = "The email address for subscription on events"
  type        = string
  default     = "example@gmail.com"
}

variable "db_snapshot_id" {
  description = "ID of the provisioned DB"
  type        = string
}