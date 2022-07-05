resource "google_redis_instance" "cache" {
  name           = "redis-cache"
  region         = var.app_location
  tier           = var.environment_name == "production" ? "STANDARD_HA" : "BASIC"
  memory_size_gb = 1
  display_name   = "Redis Cache"

  labels = {
    app = var.app_name
    env = var.environment_name
  }

  maintenance_policy {
    weekly_maintenance_window {
      day = "TUESDAY"
      start_time {
        hours   = 0
        minutes = 30
        seconds = 0
        nanos   = 0
      }
    }
  }
}
