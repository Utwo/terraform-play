resource "google_project_service" "services" {
  for_each                   = toset(var.activate_services)
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}
