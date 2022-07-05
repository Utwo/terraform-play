terraform {
  cloud {
    organization = "utwo"

    workspaces {
      name = "terra-play"
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

module "web_app" {
  source = "../../modules/web_app"

  # Input Variables
  app_name         = var.app_name
  environment_name = local.environment_name
  app_location     = local.app_location
}
