resource "google_vpc_access_connector" "cloudrun_vpc_serverless" {
  name          = "cloudrun_vpc_serverless"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
}
