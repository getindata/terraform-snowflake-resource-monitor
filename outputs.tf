output "name" {
  description = "Name of resource monitor"
  value       = resource.snowflake_resource_monitor.this.name
}

output "credit_quota" {
  description = "he number of credits allocated monthly to the resource monitor"
  value       = resource.snowflake_resource_monitor.this.credit_quota
}

output "start_timestamp" {
  description = "The date and time when the resource monitor starts monitoring credit usage"
  value       = resource.snowflake_resource_monitor.this.start_timestamp
}

output "end_timestamp" {
  description = "The date and time when the resource monitor suspends the assigned warehouses"
  value       = resource.snowflake_resource_monitor.this.end_timestamp
}

output "frequency" {
  description = "The frequency interval at which the credit usage resets to 0"
  value       = resource.snowflake_resource_monitor.this.frequency
}

output "notify_triggers" {
  description = "A list of percentage thresholds at which to send an alert to subscribed users"
  value       = resource.snowflake_resource_monitor.this.notify_triggers
}

output "notify_users" {
  description = "A list of users to receive email notifications on resource monitors"
  value       = resource.snowflake_resource_monitor.this.notify_users
}

output "suspend_immediate_triggers" {
  description = "A list of percentage thresholds at which to immediately suspend all warehouses"
  value       = resource.snowflake_resource_monitor.this.suspend_immediate_trigger
}

output "suspend_triggers" {
  description = "A list of percentage thresholds at which to suspend all warehouses"
  value       = resource.snowflake_resource_monitor.this.suspend_trigger
}

output "roles" {
  description = "Access roles created for resource monitor"
  value       = local.roles
}
