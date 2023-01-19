output "name" {
  description = "Name of resource monitor"
  value       = one(resource.snowflake_resource_monitor.this[*].name)
}

output "credit_quota" {
  description = "he number of credits allocated monthly to the resource monitor"
  value       = one(resource.snowflake_resource_monitor.this[*].credit_quota)
}

output "start_timestamp" {
  description = "The date and time when the resource monitor starts monitoring credit usage"
  value       = one(resource.snowflake_resource_monitor.this[*].start_timestamp)
}

output "end_timestamp" {
  description = "The date and time when the resource monitor suspends the assigned warehouses"
  value       = one(resource.snowflake_resource_monitor.this[*].end_timestamp)
}

output "frequency" {
  description = "The frequency interval at which the credit usage resets to 0"
  value       = one(resource.snowflake_resource_monitor.this[*].frequency)
}

output "notify_triggers" {
  description = "A list of percentage thresholds at which to send an alert to subscribed users"
  value       = one(resource.snowflake_resource_monitor.this[*].notify_triggers)
}

output "notify_users" {
  description = "A list of users to receive email notifications on resource monitors"
  value       = one(resource.snowflake_resource_monitor.this[*].notify_users)
}

output "set_for_account" {
  description = "Whether the resource monitor should be applied globally to your Snowflake account"
  value       = one(resource.snowflake_resource_monitor.this[*].set_for_account)
}

output "suspend_immediate_triggers" {
  description = "A list of percentage thresholds at which to immediately suspend all warehouses"
  value       = one(resource.snowflake_resource_monitor.this[*].suspend_immediate_triggers)
}

output "suspend_triggers" {
  description = "A list of percentage thresholds at which to suspend all warehouses"
  value       = one(resource.snowflake_resource_monitor.this[*].suspend_triggers)
}

output "warehouses" {
  description = "A list of warehouse names to apply the resource monitor to"
  value       = one(resource.snowflake_resource_monitor.this[*].warehouses)
}

output "roles" {
  description = "Access roles created for resource monitor"
  value       = local.roles
}
