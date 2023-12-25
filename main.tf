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

  notify_triggers            = var.notify_triggers
  suspend_triggers           = var.suspend_triggers
  suspend_immediate_triggers = var.suspend_immediate_triggers

  notify_users = var.notify_users

  set_for_account = var.set_for_account
  warehouses      = var.warehouses
}

module "snowflake_default_role" {
  for_each = local.default_roles

  source  = "getindata/role/snowflake"
  version = "1.2.0"
  context = module.this.context

  name            = each.key
  attributes      = ["RMN", one(snowflake_resource_monitor.this[*].name)]
  enabled         = local.create_default_roles && lookup(each.value, "enabled", true)
  descriptor_name = lookup(each.value, "descriptor_name", "snowflake-role")

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/role/snowflake"
  version = "1.2.0"
  context = module.this.context

  name            = each.key
  attributes      = ["RMN", one(snowflake_resource_monitor.this[*].name)]
  enabled         = local.create_default_roles && lookup(each.value, "enabled", true)
  descriptor_name = lookup(each.value, "descriptor_name", "snowflake-role")

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])
}

resource "snowflake_resource_monitor_grant" "this" {
  for_each = local.enabled ? transpose({ for role_name, role in local.roles : local.roles[role_name].name =>
    lookup(local.roles_definition[role_name], "resource_monitor_grants", [])
    if lookup(local.roles_definition[role_name], "enabled", true)
  }) : {}

  monitor_name = one(resource.snowflake_resource_monitor.this[*]).name
  privilege    = each.key
  roles        = each.value

  # Whole configuration should be maintained "as Code" so below
  # options should be disabled in all use-cases
  enable_multiple_grants = false
  with_grant_option      = false
}
