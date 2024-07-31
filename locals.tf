locals {
  name_from_descriptor = module.monitor_label.enabled ? trim(replace(
    lookup(module.monitor_label.descriptors, var.descriptor_name, module.monitor_label.id), "/${module.monitor_label.delimiter}${module.monitor_label.delimiter}+/", module.monitor_label.delimiter
  ), module.monitor_label.delimiter) : null

  enabled              = module.this.enabled
  create_default_roles = local.enabled && var.create_default_roles

  default_roles_definition = {
    readonly = {
      resource_monitor_grants = {
        privileges        = ["MONITOR"]
        with_grant_option = false
        all_privileges    = null
      }
    }
    admin = {
      resource_monitor_grants = {
        privileges        = null
        with_grant_option = false
        all_privileges    = true
      }
    }
  }

  provided_roles = { for role_name, role in var.roles : role_name => {
    for k, v in role : k => v
    if v != null
  } }
  roles_definition = module.roles_deep_merge.merged

  default_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if contains(keys(local.default_roles_definition), role_name)
  }
  custom_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if !contains(keys(local.default_roles_definition), role_name)
  }

  roles = {
    for role_name, role in merge(
      module.snowflake_default_role,
      module.snowflake_custom_role
    ) : role_name => role
    if role.name != null
  }
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles_definition, local.provided_roles]
}
