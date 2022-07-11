variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "app_location" {
  description = "location/region for the resources"
  type        = string
}

variable "environment_name" {
  description = "environment name"
  type        = string
}

variable "app_name" {
  description = "application name"
  type        = string
}

variable "db_allowlist" {
  description = "Allowlist for DB public access"
  type        = list(object({ name = string, value = string }))
  default     = []
}
