module "monitor_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = module.this.context

  delimiter           = coalesce(module.this.context.delimiter, "_")
  regex_replace_chars = coalesce(module.this.context.regex_replace_chars, "/[^_a-zA-Z0-9]/")
  label_value_case    = coalesce(module.this.context.label_value_case, "upper")
}

resource "snowflake_resource_monitor" "this" {
  count = local.enabled ? 1 : 0

  name = local.name_from_descriptor

  credit_quota = var.credit_quota

  frequency       = var.frequency
  start_timestamp = var.start_timestamp
  end_timestamp   = var.end_timestamp

  notify_triggers           = var.notify_triggers
  suspend_trigger           = var.suspend_trigger
  suspend_immediate_trigger = var.suspend_immediate_trigger

  notify_users = var.notify_users

  set_for_account = var.set_for_account
  warehouses      = var.warehouses
}

module "snowflake_default_role" {
  for_each = local.default_roles

  source  = "getindata/role/snowflake"
  version = "2.1.0"
  context = module.this.context

  name            = each.key
  attributes      = ["RMN", one(snowflake_resource_monitor.this[*].name)]
  enabled         = local.create_default_roles && lookup(each.value, "enabled", true)
  descriptor_name = lookup(each.value, "descriptor_name", "snowflake-role")

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])

  account_objects_grants = {
    "RESOURCE MONITOR" = [{
      all_privileges    = each.value.resource_monitor_grants.all_privileges
      privileges        = each.value.resource_monitor_grants.privileges
      with_grant_option = each.value.resource_monitor_grants.with_grant_option
      object_name       = one(snowflake_resource_monitor.this[*].name)
    }]
  }

  depends_on = [
    snowflake_resource_monitor.this
  ]
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/role/snowflake"
  version = "2.1.0"
  context = module.this.context

  name            = each.key
  attributes      = ["RMN", one(snowflake_resource_monitor.this[*].name)]
  enabled         = lookup(each.value, "enabled", true)
  descriptor_name = lookup(each.value, "descriptor_name", "snowflake-role")

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])

  account_objects_grants = {
    "RESOURCE MONITOR" = [{
      all_privileges    = each.value.resource_monitor_grants.all_privileges
      privileges        = each.value.resource_monitor_grants.privileges
      with_grant_option = each.value.resource_monitor_grants.with_grant_option
      object_name       = one(snowflake_resource_monitor.this[*].name)
    }]
  }

  depends_on = [
    snowflake_resource_monitor.this
  ]
}
