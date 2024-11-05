/*
* # Simple example for Snowflake Resource Monitor module
*
* This example creates resource monitor for account, 
* that will notify account administrators
* when 50%, 80%,90% of credit quota is reached, will also suspend
* all warehouses in the account when 100% quota is reached.
*/

module "resource_monitor" {
  source = "../../"

  name = "example_resource_monitor"

  credit_quota = 200

  notify_triggers = [50, 80, 90]
  suspend_trigger = 100
}
