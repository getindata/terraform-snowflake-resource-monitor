<!-- BEGIN_TF_DOCS -->
# Simple example for Snowflake Resource Monitor module

This example creates resource monitor for account,
that will notify account administrators
when 50%, 80%,90% of credit quota is reached, will also suspend
all warehouses in the account when 100% quota is reached.



## Inputs

No inputs.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_monitor"></a> [resource\_monitor](#module\_resource\_monitor) | ../../ | n/a |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_monitor"></a> [resource\_monitor](#output\_resource\_monitor) | Details of resource monitor |

## Providers

No providers.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.47 |

## Resources

No resources.
<!-- END_TF_DOCS -->