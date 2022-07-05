resource "google_cloud_run_service" "web_app_backend" {
  name     = "web-app-backend"
  location = var.app_location

  metadata {
    labels = {
      app = var.app_name
      env = var.environment_name
    }
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }


  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
        resources {
          limits = {
            cpu    = var.app_limit_cpu
            memory = var.app_limit_memory
          }
        }
        env {
          name  = "NODE_ENV"
          value = "production"
        }
        env {
          name  = "APP_ENV"
          value = var.environment_name
        }
        env {
          name  = "REDIS_HOST"
          value = google_redis_instance.cache.host
        }
        env {
          name  = "BUCKET_NAME"
          value = google_storage_bucket.assets.name
        }
        env {
          name  = "DB_HOST"
          value = google_sql_database_instance.terra_instance.private_ip_address
        }
        env {
          name  = "DB_NAME"
          value = local.db_name
        }
        env {
          name  = "DB_USERNAME"
          value = local.db_username
        }
        env {
          name = "DB_PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.db_password.secret_id
              key  = "2"
            }
          }
        }
      }
      service_account_name = google_service_account.cloud_run_service_account.email
      timeout_seconds      = 3000 # 50 minutes, for longer websockets connection
    }

    metadata {
      labels = {
        app = var.app_name
        env = var.environment_name
      }
      annotations = {
        "autoscaling.knative.dev/maxScale"         = "15"
        "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"
        "run.googleapis.com/execution-environment" = "gen2"
        "run.googleapis.com/launch-stage"          = "BETA"
        "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"
        "run.googleapis.com/vpc-access-connector"  = google_vpc_access_connector.cloudrun_vpc_serverless.name
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [
      metadata.0.annotations,
    ]
  }

  depends_on = [google_secret_manager_secret_version.db_password_data]
}

resource "google_cloud_run_service_iam_member" "cloudrun_all_users" {
  service  = google_cloud_run_service.web_app_backend.name
  location = google_cloud_run_service.web_app_backend.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
