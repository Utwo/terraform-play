# resource "google_service_account" "gke_sa" {
#   account_id   = "gke-sa"
#   display_name = "Service Account for GKE cluster"
# }

# resource "google_container_cluster" "primary" {
#   name     = "gke-main-cluster-${var.environment_name}"
#   location = var.app_location
#   # We can't create a cluster with no node pool defined, but we want to only use
#   # separately managed node pools. So we create the smallest possible default
#   # node pool and immediately delete it.
#   remove_default_node_pool = true
#   initial_node_count       = 1
# }

# resource "google_container_node_pool" "primary_preemptible_nodes" {
#   name       = "default-node-pool"
#   cluster    = google_container_cluster.primary.name
#   node_count = 1
#   location   = var.app_location

#   node_config {
#     preemptible  = true
#     machine_type = "e2-medium"

#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     service_account = google_service_account.gke_sa.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }
