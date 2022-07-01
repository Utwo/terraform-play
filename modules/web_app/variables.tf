variable "environment_name" {
  description = "Name for the environment"
  type        = string
}

variable "db_name" {
  description = "Name for DB"
  type        = string
}


variable "db_pass" {
  description = "Password for DB"
  type        = string
  sensitive   = true
}
