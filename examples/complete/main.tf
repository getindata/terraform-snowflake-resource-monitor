/*
* # Complete example for Snowflake Resource Monitor module
*
* This example creates:
*
* * Resource monitor for warehouse, that will ill notify account 
*   administrators and specified users when 50%, 80% of credit 
*   quota is reached, will also suspend all warehouses assigned 
*   to this monitor.
* * Resource monitor for account, that will notify account 
*   administrators when 50%, 80%,90% of credit quota is reached,
*   will also suspend immediately (all running queries will be cancelled)
*   all warehouses in the account when 100% quota is reached.
*/

resource "snowflake_user" "this_user" {
  name    = "example_user"
  comment = "Example snowflake user."

  must_change_password = true
}

resource "snowflake_user" "this_dbt" {
  name    = "dbt_user"
  comment = "DBT user."
}


resource "snowflake_account_role" "this_admin" {
  name    = "ADMIN"
  comment = "Role for Snowflake Administrators"
}

resource "snowflake_account_role" "this_dev" {
  name    = "USER"
  comment = "Role for Snowflake Users"
}

module "warehouse_users" {
  source  = "getindata/warehouse/snowflake"
  version = "2.2.0"

  name    = "warehouse_users"
  comment = "warehouse for users"

  warehouse_size = "x-small"

  auto_resume         = true
  auto_suspend        = 600
  initially_suspended = true

  create_default_roles = true

  roles = {
    usage = {
      granted_to_roles = ["USER"]
    }
  }
}

module "warehouse_dbt" {
  source  = "getindata/warehouse/snowflake"
  version = "2.2.0"

  name    = "warehouse_dbt"
  comment = "warehouse for dbt usage"

  warehouse_size = "x-small"

  auto_resume         = true
  auto_suspend        = 600
  initially_suspended = true

  create_default_roles = true

  roles = {
    usage = {
      granted_to_users = ["dbt_user"]
    }
  }

  depends_on = [snowflake_user.this_dbt]
}

/*
 * Resource monitor for warehouse
 * Will notify account administrators and specified users when 
 * 50%, 80% of credit quota is reached.
 * Will notify account administrators plus specified users and 
 * suspend all warehouses assigned to this monitor.
*/
module "warehouse_resource_monitor" {
  source = "../../"

  descriptor_formats = {
    snowflake-role = {
      labels = ["attributes", "name"]
      format = "%v_%v"
    }
    snowflake-resource-monitor = {
      labels = ["name", "attributes"]
      format = "%v_%v"
    }
  }

  enabled = true

  name       = "warehouse"
  attributes = ["resource", "monitor"]

  credit_quota = 20

  frequency       = "MONTHLY"
  start_timestamp = formatdate("YYYY-MM-DD HH:MM", timeadd(timestamp(), "1h"))
  end_timestamp   = formatdate("YYYY-MM-DD HH:MM", timeadd(timestamp(), "1000h"))

  suspend_trigger = 100
  notify_triggers = [50, 80]

  warehouses = [module.warehouse_users.warehouse.name]

  create_default_roles = true

  roles = {
    admin = {
      granted_to_roles = [snowflake_account_role.this_admin.name]
    }
    custom_role = {
      resource_monitor_grants = {
        privileges = ["MONITOR", "MODIFY"]
      }
      granted_to_roles = [snowflake_account_role.this_dev.name]
      granted_to_users = [nonsensitive(snowflake_user.this_user.name)]
    }
  }


  depends_on = [
    snowflake_account_role.this_dev,
    snowflake_account_role.this_admin,
    snowflake_user.this_user,
    module.warehouse_users.warehouse,
  ]
}

/* 
 * Resource monitor for account.
 * Will notify account administrators when 50%, 80%,90%
 * of credit quota is reached.
 * Will notify account administrators and suspend immediately 
 * (all running queries will be cancelled) all warehouses in
 * the accouny when 100% quota is reached.
*/
module "account_resource_monitor" {
  source = "../../"

  descriptor_formats = {
    snowflake-role = {
      labels = ["attributes", "name"]
      format = "%v_%v"
    }
    snowflake-resource-monitor = {
      labels = ["name", "attributes"]
      format = "%v_%v"
    }
  }

  enabled         = true
  set_for_account = true

  name       = "account"
  attributes = ["resource", "monitor"]

  credit_quota = 200

  start_timestamp = formatdate("YYYY-MM-DD HH:MM", timeadd(timestamp(), "1h"))
  frequency       = "MONTHLY"

  notify_triggers           = [50, 80, 90]
  suspend_immediate_trigger = 100

  create_default_roles = true

  roles = {
    admin = {
      granted_to_roles = [snowflake_account_role.this_admin.name]
    }
  }

  depends_on = [snowflake_account_role.this_admin]

}
