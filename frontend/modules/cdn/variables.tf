variable "project" {
  description = "The name of the project. Default is 'project'"
  type        = string
  default     = "project"
}

variable "env" {
  description = "The name of the environment. Default is 'env'"
  type        = string
  default     = "env"
}

variable "url" {
  description = "The URL of the web application which will be distributed"
  type        = string
}

variable "tags" {
  description = "The map of the tags to associate with. Default is '{}'"
  type        = map(string)
  default     = {}
}