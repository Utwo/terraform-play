resource "google_storage_bucket" "assets" {
  name                        = "${var.app_name}-assets-${var.environment_name}"
  location                    = "EU"
  force_destroy               = true
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true

  labels = {
    app = var.app_name
    env = var.environment_name
  }
}

resource "google_storage_bucket_iam_member" "cloud_run_member" {
  bucket = google_storage_bucket.assets.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_storage_bucket_iam_member" "all_users_read" {
  bucket = google_storage_bucket.assets.name
  role   = "roles/storage.legacyBucketWriter"
  member = "allUsers"
}
