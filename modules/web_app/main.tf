terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "google_compute_network" "default" {
  name = "default"
}

locals {
  db_name     = "terradb-${var.environment_name}"
  db_username = "admin"
  db_password = random_password.password.result
}
