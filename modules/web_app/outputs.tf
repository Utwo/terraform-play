output "redis_cache" {
  value = google_redis_instance.cache.host
}

output "database_private" {
  value = google_sql_database_instance.terra_instance.private_ip_address
}

output "database_public" {
  value = google_sql_database_instance.terra_instance.public_ip_address
}

output "web_app_url" {
  value = google_cloud_run_service.web_app_backend.status[0].url
}
