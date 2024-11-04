data "context_label" "this" {
  delimiter  = local.context_template == null ? var.name_scheme.delimiter : null
  properties = local.context_template == null ? var.name_scheme.properties : null
  template   = local.context_template

  replace_chars_regex = var.name_scheme.replace_chars_regex

  values = merge(
    var.name_scheme.extra_values,
    { name = var.name }
  )
}

resource "snowflake_resource_monitor" "this" {
  name = data.context_label.this.rendered

  credit_quota = var.credit_quota

  frequency       = var.frequency
  start_timestamp = var.start_timestamp
  end_timestamp   = var.end_timestamp

  notify_triggers           = var.notify_triggers
  suspend_trigger           = var.suspend_trigger
  suspend_immediate_trigger = var.suspend_immediate_trigger

  notify_users = var.notify_users
}
moved {
  from = snowflake_resource_monitor.this[0]
  to   = snowflake_resource_monitor.this
}

module "snowflake_default_role" {
  for_each = var.create_default_roles ? local.default_roles : tomap({})

  source  = "getindata/role/snowflake"
  version = "3.0.1"

  name = each.key
  name_scheme = merge(
    local.default_role_naming_scheme,
    lookup(each.value, "name_scheme", {})
  )

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])

  account_objects_grants = {
    "RESOURCE MONITOR" = [{
      all_privileges    = each.value.resource_monitor_grants.all_privileges
      privileges        = each.value.resource_monitor_grants.privileges
      with_grant_option = each.value.resource_monitor_grants.with_grant_option
      object_name       = snowflake_resource_monitor.this.name
    }]
  }
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/role/snowflake"
  version = "3.0.1"

  name = each.key
  name_scheme = merge(
    local.default_role_naming_scheme,
    lookup(each.value, "name_scheme", {})
  )

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])

  account_objects_grants = {
    "RESOURCE MONITOR" = [{
      all_privileges    = each.value.resource_monitor_grants.all_privileges
      privileges        = each.value.resource_monitor_grants.privileges
      with_grant_option = each.value.resource_monitor_grants.with_grant_option
      object_name       = snowflake_resource_monitor.this.name
    }]
  }
}
