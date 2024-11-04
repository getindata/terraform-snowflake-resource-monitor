<!-- BEGIN_TF_DOCS -->
# Complete example for Snowflake Resource Monitor module

This example creates:

* Resource monitor for warehouse, that will ill notify account
  administrators and specified users when 50%, 80% of credit
  quota is reached, will also suspend all warehouses assigned
  to this monitor.
* Resource monitor for account, that will notify account
  administrators when 50%, 80%,90% of credit quota is reached,
  will also suspend immediately (all running queries will be cancelled)
  all warehouses in the account when 100% quota is reached.



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context_templates"></a> [context\_templates](#input\_context\_templates) | A map of context templates to use for generating user names | `map(string)` | n/a | yes |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_monitor_1"></a> [resource\_monitor\_1](#module\_resource\_monitor\_1) | ../../ | n/a |
| <a name="module_resource_monitor_2"></a> [resource\_monitor\_2](#module\_resource\_monitor\_2) | ../../ | n/a |
| <a name="module_resource_monitor_3"></a> [resource\_monitor\_3](#module\_resource\_monitor\_3) | ../../ | n/a |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_monitor_1"></a> [resource\_monitor\_1](#output\_resource\_monitor\_1) | Details of resource monitor |
| <a name="output_resource_monitor_2"></a> [resource\_monitor\_2](#output\_resource\_monitor\_2) | Details of resource monitor |
| <a name="output_resource_monitor_3"></a> [resource\_monitor\_3](#output\_resource\_monitor\_3) | Details of resource monitor |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | ~> 0.54 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_context"></a> [context](#requirement\_context) | >=0.4.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.54 |

## Resources

| Name | Type |
|------|------|
| [snowflake_account_role.this_admin](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/account_role) | resource |
| [snowflake_account_role.this_dev](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/account_role) | resource |
| [snowflake_user.this_dbt](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/user) | resource |
| [snowflake_user.this_user](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/user) | resource |
<!-- END_TF_DOCS -->
