/*
* # Snowflake Resource Monitor
* 
* Terraform module that can create and manage Snowflake Resource Monitors.
* Additionally it creates predefined access roles to simplyfiy user-access management
*/

resource "snowflake_resource_monitor" "this" {
  count = local.enabled

  name = local.name_from_descriptor

  credit_quota = var.credit_quota

  frequency       = var.frequency
  start_timestamp = var.start_timestamp
  end_timestamp   = var.end_timestamp

  notify_triggers            = var.notify_triggers
  suspend_triggers           = var.suspend_triggers
  suspend_immediate_triggers = var.suspend_immediate_triggers

  notify_users = var.notify_users

  set_for_account = var.set_for_account
  warehouses      = var.warehouses
}

module "snowflake_role" {
  for_each = local.roles

  source  = "getindata/role/snowflake"
  version = "1.0.0"

  context = module.this.context
  enabled = module.this.enabled && lookup(each.value, "enabled", true)

  name       = each.key
  attributes = ["RMN", one(snowflake_resource_monitor.this).name]

  granted_to_users = lookup(each.value, "granted_to_users", [])
  granted_to_roles = lookup(each.value, "granted_to_roles", [])
  granted_roles    = lookup(each.value, "granted_roles", [])
}

resource "snowflake_resource_monitor_grant" "this" {
  for_each = module.this.enabled ? transpose(
    {
      for role_name, role in module.snowflake_role : module.snowflake_role[role_name].name =>
      local.roles[role_name].privileges if lookup(local.roles[role_name], "enabled", true)
    }
  ) : {}

  monitor_name = one(resource.snowflake_resource_monitor.this[*]).name
  privilege    = each.key
  roles        = each.value

  # Whole configuration should be maintained "as Code" so below
  # options should be disabled in all use-cases
  enable_multiple_grants = false
  with_grant_option      = false
}
