terraform {
  cloud {
    organization = "utwo"

    workspaces {
      tags = ["terra-play-development", "terra-play-production"]
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }
}

locals {
  app_location = var.app_location
}

provider "google" {
  project = var.project_id
  region  = local.app_location
}

module "web_app" {
  source = "./modules/web_app"

  # Input Variables
  app_name         = var.app_name
  environment_name = var.environment_name
  app_location     = local.app_location
  db_allowlist     = var.db_allowlist
}
