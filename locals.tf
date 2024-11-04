locals {
  context_template = lookup(var.context_templates, var.name_scheme.context_template_name, null)

  default_role_naming_scheme = {
    properties            = ["prefix", "environment", "resource-monitor", "name"]
    context_template_name = "snowflake-resource-monitor-role"
    extra_values = {
      prefix           = "rmn"
      resource-monitor = var.name
    }
  }

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
