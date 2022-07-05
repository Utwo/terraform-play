resource "google_sql_database" "terra_db" {
  name     = local.db_name
  instance = google_sql_database_instance.terra_instance.name
}

resource "google_sql_database_instance" "terra_instance" {
  name             = "terra-db"
  region           = var.app_location
  database_version = "POSTGRES_14"
  settings {
    tier              = var.db_machine
    availability_type = var.environment_name == "production" ? "REGIONAL" : "ZONAL"
    backup_configuration {
      enabled                        = var.environment_name == "production"
      point_in_time_recovery_enabled = var.environment_name == "production"
    }
    ip_configuration {
      private_network = data.google_compute_network.default.id
      ipv4_enabled    = true
      dynamic "authorized_networks" {
        for_each = var.db_allowlist
        iterator = db_allowlist

        content {
          name  = db_allowlist.value.name
          value = db_allowlist.value.value
        }
      }
    }
  }

  deletion_protection = "true"

  depends_on = [google_service_networking_connection.private_vpc_connection]
}


resource "google_sql_user" "local_user" {
  instance = google_sql_database_instance.terra_instance.name
  name     = local.db_username
  password = local.db_password
}

resource "google_sql_user" "webapp_user" {
  instance = google_sql_database_instance.terra_instance.name
  name     = google_service_account.cloud_run_service_account.account_id
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}
