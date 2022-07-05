resource "google_secret_manager_secret" "db_password" {
  secret_id = "db_password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "db_password_data" {
  secret      = google_secret_manager_secret.db_password.name
  secret_data = local.db_password
}

resource "google_secret_manager_secret_iam_member" "db_secret_access" {
  secret_id  = google_secret_manager_secret.db_password.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
  depends_on = [google_secret_manager_secret.db_password]
}
