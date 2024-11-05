/*
* # Complete example for Snowflake Resource Monitor module
*
* This example creates:
*
* * Resource monitor, that will will notify account 
*   administrators and specified users when 50%, 80% of credit 
*   quota is reached, will also suspend all warehouses assigned 
*   to this monitor.
* * Resource monitor, that will notify account 
*   administrators when 50%, 80%,90% of credit quota is reached,
*   will also suspend immediately (all running queries will be cancelled)
*   all warehouses in the account when 100% quota is reached.
* * Resource monitor, simmilar to the abve, with different name scheme
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

module "resource_monitor_1" {
  source = "../../"

  name = "test_1"
  name_scheme = {
    properties = ["environment", "project", "name"]
    extra_values = {
      project = "project"
    }
  }

  credit_quota = 20

  frequency       = "MONTHLY"
  start_timestamp = formatdate("YYYY-MM-DD hh:mm", timeadd(plantimestamp(), "4h"))
  end_timestamp   = formatdate("YYYY-MM-DD hh:mm", timeadd(plantimestamp(), "1000h"))

  suspend_trigger = 100
  notify_triggers = [50, 80]

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
      granted_to_users = [snowflake_user.this_user.name]
    }
  }
}

module "resource_monitor_2" {
  source = "../../"

  name              = "test_2"
  context_templates = var.context_templates

  credit_quota = 200

  start_timestamp = formatdate("YYYY-MM-DD hh:mm", timeadd(plantimestamp(), "4h"))
  frequency       = "MONTHLY"

  notify_triggers           = [50, 80, 90]
  suspend_immediate_trigger = 100

  create_default_roles = true

  roles = {
    admin = {
      granted_to_roles = [snowflake_account_role.this_admin.name]
    }
  }

}

module "resource_monitor_3" {
  source = "../../"

  name = "test_3"
  name_scheme = {
    context_template_name = "snowflake-project-resource-monitor"
    extra_values = {
      project = "project"
    }
  }
  context_templates = var.context_templates

  credit_quota = 10

  start_timestamp = formatdate("YYYY-MM-DD hh:mm", timeadd(plantimestamp(), "4h"))
  frequency       = "MONTHLY"

  notify_triggers           = [50, 80, 90]
  suspend_immediate_trigger = 100

  create_default_roles = true

  roles = {
    admin = {
      granted_to_roles = [snowflake_account_role.this_admin.name]
    }
  }

}
