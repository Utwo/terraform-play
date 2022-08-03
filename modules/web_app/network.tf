resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "${var.project_id}-${var.network_name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name                     = "${var.project_id}-${var.subnet_name}"
  ip_cidr_range            = var.subnet_ips
  region                   = var.region_name
  private_ip_google_access = "true"
  network                  = google_compute_network.vpc_network.name
  project                  = var.project_id
}

resource "google_compute_address" "ip_nat" {
  project      = var.project_id
  region       = var.region_name
  name         = "nat-external-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}
resource "google_compute_global_address" "lb_global_ip_ingress" {
  project      = var.project_id
  name         = var.ingress_ip_name
  address_type = "EXTERNAL"
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "router"
  region  = google_compute_subnetwork.vpc_subnetwork.region
  network = google_compute_network.vpc_network.id
}
resource "google_compute_router_nat" "nat" {
  name                   = "router-nat"
  router                 = google_compute_router.router.name
  region                 = google_compute_router.router.region
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.ip_nat.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_vpc_access_connector" "cloudrun_vpc_serverless" {
  name          = "cloudrun-vpc-serverless"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.default.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
