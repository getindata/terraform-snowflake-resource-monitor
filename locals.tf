locals {
  enabled = module.this.enabled ? 1 : 0

  name_from_descriptor = trim(replace(
    lookup(module.this.descriptors, var.descriptor_name, module.this.id), "/${module.this.delimiter}${module.this.delimiter}+/", module.this.delimiter
  ), module.this.delimiter)

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
