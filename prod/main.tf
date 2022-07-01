terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }
}

provider "google" {
  project = "autocode-347209"
  region  = "us-central1"
}

variable "db_name" {
  description = "name for database"
  type        = string
}

variable "db_pass" {
  description = "password for database"
  type        = string
  sensitive   = true
}

locals {
  environment_name = "prod"
}

module "web_app" {
  source = "../modules/web_app"

  # Input Variables
  environment_name = local.environment_name
  db_name          = var.db_name
  db_pass          = var.db_pass
}
