output "redis_cache" {
  value = module.web_app.redis_cache
}

output "database_private" {
  value = module.web_app.database_private
}

output "database_public" {
  value = module.web_app.database_public
}

output "web_app_url" {
  value = module.web_app.web_app_url
}
