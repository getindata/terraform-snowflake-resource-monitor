output "resource_monitor" {
  description = "Details of the resource monitor"
  value       = one(resource.snowflake_resource_monitor.this[*])
}

output "roles" {
  description = "Functional roles created for warehouse"
  value       = module.snowflake_role
}
