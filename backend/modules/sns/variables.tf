variable "project" {
  description = "The project name. Default is 'project'"
  type        = string
  default     = "project"
}

variable "tags" {
  description = "The map of the tags to associate with. Default is '{}'"
  type        = map(string)
  default     = {}
}

variable "email" {
  description = "The email address for subscription on events"
  type        = string
}