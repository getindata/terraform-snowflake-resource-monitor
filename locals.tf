locals {
  name_from_descriptor = module.monitor_label.enabled ? trim(replace(
    lookup(module.monitor_label.descriptors, var.descriptor_name, module.monitor_label.id), "/${module.monitor_label.delimiter}${module.monitor_label.delimiter}+/", module.monitor_label.delimiter
  ), module.monitor_label.delimiter) : null

  default_roles = var.create_default_roles ? {
    monitor = {
      privileges = ["MONITOR"]
    }
    modify = {
      privileges = ["MODIFY"]
    }
    admin = {
      privileges = ["MODIFY", "MONITOR"]
    }
  } : {}

  roles = module.roles_deep_merge.merged
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles, var.roles]
}
