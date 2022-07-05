variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "environment_name" {
  description = "Name for the environment"
  type        = string
}

variable "app_location" {
  description = "Location where to run the app"
  type        = string
  default     = "value"
}

variable "db_allowlist" {
  description = "Allowlist for DB public access"
  type        = list(object({ name = string, value = string }))
  default     = []
}

variable "db_machine" {
  description = "Machine type for DB"
  type        = string
  default     = "db-f1-micro"
}

variable "app_limit_cpu" {
  description = "CPU limit for Cloud Run web app"
  type        = string
  default     = "1000m"
}

variable "app_limit_memory" {
  description = "Memory limit for Cloud Run web app"
  type        = string
  default     = "512Mi"
}

variable "cloudrun_roles_list" {
  type    = list(string)
  default = []
}

variable "billing_account_name" {
  type        = string
  description = "The name of the billing account"
  default     = "My Billing Account"
}

variable "activate_services" {
  type = list(any)
  default = [
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "vpcaccess.googleapis.com",
    "redis.googleapis.com",
    "sqladmin.googleapis.com",
    "billingbudgets.googleapis.com"
  ]
}
