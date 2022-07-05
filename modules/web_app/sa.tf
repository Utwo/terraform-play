resource "google_service_account" "cloud_run_service_account" {
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run Service Account"
  description  = "Service Account for main Cloud Run web app"
}

# resource "google_project_iam_member" "cloudrun_iam" {
#   count  = length(var.cloudrun_roles_list)
#   role   = var.cloudrun_roles_list[count.index]
#   member = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
# }
