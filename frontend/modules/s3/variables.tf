variable "project" {
  description = "The name of the project. Default is 'project'"
  type        = string
  default     = "project"
}

variable "env" {
  description = "Environment name. Default is 'env'"
  type        = string
  default     = "env"
}

variable "tags" {
  description = "The map of tags to associate with. Default is '{}'"
  type        = map(string)
  default     = {}
}