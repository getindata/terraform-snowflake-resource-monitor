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
  name         = "Example user"
  login_name   = "example_user"
  comment      = "Example snowflake user."
  password     = "P@55w0rd"
  display_name = "Example User"
  email        = "snowflake@sexample.com"

  must_change_password = true
}

resource "snowflake_user" "this_dbt" {
  name       = "DBT user"
  login_name = "dbt_user"
  comment    = "DBT user."
}


resource "snowflake_role" "this_admin" {
  name    = "ADMIN"
  comment = "Role for Snowflake Administrators"
}

resource "snowflake_role" "this_dev" {
  name    = "USER"
  comment = "Role for Snowflake Users"
}

module "warehouse_users" {
  source  = "getindata/warehouse/snowflake"
  version = "1.0.0"

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
  version = "1.0.0"

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
  attributes = ["resource_monitor"]

  credit_quota = 20

  frequency       = "MONTHLY"
  start_timestamp = "2022-12-01T00:00:00"
  end_timestamp   = "2023-03-31T00:00:00"

  suspend_triggers = [100]
  notify_triggers  = [50, 80]
  notify_users     = ["example_user"]

  warehouses = [module.warehouse_users.warehouse.name]

  create_default_roles = true

  roles = {
    admin = {
      granted_to_roles = [snowflake_role.this_admin.name]
    }
    custom_role = {
      privileges       = ["MONITOR", "MODIFY"]
      granted_to_roles = [snowflake_role.this_dev.name]
      granted_to_users = [snowflake_user.this_user.name]
    }
  }
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
  attributes = ["resource_monitor"]

  credit_quota = 200

  frequency = "MONTHLY"

  notify_triggers            = [50, 80, 90]
  notify_users               = ["example_user"]
  suspend_immediate_triggers = [100]

  create_default_roles = true

  roles = {
    admin = {
      granted_to_roles = [snowflake_role.this_admin.name]
    }
  }

}
