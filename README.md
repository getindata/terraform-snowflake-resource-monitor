# Snowflake Resource Monitor Terraform Module

<!--- Pick Cloud provider Badge -->
<!---![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white) -->
<!---![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white) -->
![Snowflake](https://img.shields.io/badge/-SNOWFLAKE-249edc?style=for-the-badge&logo=snowflake&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

<!--- Replace repository name -->
![License](https://badgen.net/github/license/getindata/terraform-snowflake-resource-monitor/)
![Release](https://badgen.net/github/release/getindata/terraform-snowflake-resource-monitor/)

<p align="center">
  <img height="150" src="https://getindata.com/img/logo.svg">
  <h3 align="center">We help companies turn their data into assets</h3>
</p>

---

Terraform module for Snowflake Resource Monitor management

- Creates Snowflake Resource Monitor
- Can create custom Snowflake Roles with role-to-role, role-to-user assignments
- Can create a set of default, functional roles to simplify access management:
  - `ADMIN` - full access
  - `MODIFY` - abillity to modify resource monitor
  - `MONITOR` - abillity to monitor resource monitor

## USAGE

```terraform
module "resource_monitors" {
  source = "getindata/resource-monitor/snowflake"

  name = "example_resource_monitor"

  credit_quota = 50

  notify_triggers            = [50, 80, 90]
  suspend_triggers           = [100]
  suspend_immediate_triggers = [110]

  set_for_account = true
}
```

## EXAMPLES

- [Simple](examples/simple)
- [Complete](examples/complete)

## Breaking changes in v4.x of the module

Due to replacement of nulllabel (`context.tf`) with context provider, some **breaking changes** were introduced in `v4.0.0` version of this module.

List of code and variable (API) changes:

- Removed `context.tf` file (a single-file module with additional variables), which implied a removal of all its variables (except `name`):
  - `descriptor_formats`
  - `label_value_case`
  - `label_key_case`
  - `id_length_limit`
  - `regex_replace_chars`
  - `label_order`
  - `additional_tag_map`
  - `tags`
  - `labels_as_tags`
  - `attributes`
  - `delimiter`
  - `stage`
  - `environment`
  - `tenant`
  - `namespace`
  - `enabled`
  - `context`
- Remove support `enabled` flag - that might cause some backward compatibility issues with terraform state (please take into account that proper `move` clauses were added to minimize the impact), but proceed with caution
- Additional `context` provider configuration
- New variables were added, to allow naming configuration via `context` provider:
  - `context_templates`
  - `name_schema`

Additionally, due to breaking changes introduced in `snowflake` terraform provider `v0.96.0` (`snowflake_resource_monitor` resource):

- Removal of `set_for_account` variable / flag (will be settable on account resource)
- Removal of `warehouses` variable (will be settable on warehouse resource)

<!-- BEGIN_TF_DOCS -->




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context_templates"></a> [context\_templates](#input\_context\_templates) | Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration | `map(string)` | `{}` | no |
| <a name="input_create_default_roles"></a> [create\_default\_roles](#input\_create\_default\_roles) | Whether the default roles should be created | `bool` | `false` | no |
| <a name="input_credit_quota"></a> [credit\_quota](#input\_credit\_quota) | The number of credits allocated monthly to the resource monitor. | `number` | `null` | no |
| <a name="input_end_timestamp"></a> [end\_timestamp](#input\_end\_timestamp) | The date and time when the resource monitor suspends the assigned warehouses. | `string` | `null` | no |
| <a name="input_frequency"></a> [frequency](#input\_frequency) | The frequency interval at which the credit usage resets to 0. If you set a frequency for a resource monitor, you must also set START\_TIMESTAMP. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource | `string` | n/a | yes |
| <a name="input_name_scheme"></a> [name\_scheme](#input\_name\_scheme) | Naming scheme configuration for the resource. This configuration is used to generate names using context provider:<br/>    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`<br/>    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`<br/>    - `context_template_name` - name of the context template used to create the name<br/>    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name<br/>    - `extra_values` - map of extra label-value pairs, used to create a name<br/>    - `uppercase` - convert name to uppercase | <pre>object({<br/>    properties            = optional(list(string), ["environment", "name"])<br/>    delimiter             = optional(string, "_")<br/>    context_template_name = optional(string, "snowflake-resource-monitor")<br/>    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")<br/>    extra_values          = optional(map(string))<br/>    uppercase             = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_notify_triggers"></a> [notify\_triggers](#input\_notify\_triggers) | A list of percentage thresholds at which to send an alert to subscribed users. | `list(number)` | `null` | no |
| <a name="input_notify_users"></a> [notify\_users](#input\_notify\_users) | Specifies the list of users to receive email notifications on resource monitors. | `list(string)` | `null` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Roles created on the Resource Monitor level | <pre>map(object({<br/>    name_scheme = optional(object({<br/>      properties            = optional(list(string))<br/>      delimiter             = optional(string)<br/>      context_template_name = optional(string)<br/>      replace_chars_regex   = optional(string)<br/>      extra_labels          = optional(map(string))<br/>      uppercase             = optional(bool)<br/>    }))<br/>    comment              = optional(string)<br/>    role_ownership_grant = optional(string)<br/>    granted_roles        = optional(list(string))<br/>    granted_to_roles     = optional(list(string))<br/>    granted_to_users     = optional(list(string))<br/>    resource_monitor_grants = optional(object({<br/>      all_privileges    = optional(bool)<br/>      with_grant_option = optional(bool, false)<br/>      privileges        = optional(list(string))<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_start_timestamp"></a> [start\_timestamp](#input\_start\_timestamp) | The date and time when the resource monitor starts monitoring credit usage for the assigned warehouses. | `string` | `null` | no |
| <a name="input_suspend_immediate_trigger"></a> [suspend\_immediate\_trigger](#input\_suspend\_immediate\_trigger) | The number that represents the percentage threshold at which to immediately suspend all warehouses. | `number` | `null` | no |
| <a name="input_suspend_trigger"></a> [suspend\_trigger](#input\_suspend\_trigger) | The number that represents the percentage threshold at which to suspend all warehouses. | `number` | `null` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_roles_deep_merge"></a> [roles\_deep\_merge](#module\_roles\_deep\_merge) | Invicton-Labs/deepmerge/null | 0.1.5 |
| <a name="module_snowflake_custom_role"></a> [snowflake\_custom\_role](#module\_snowflake\_custom\_role) | getindata/role/snowflake | 3.1.0 |
| <a name="module_snowflake_default_role"></a> [snowflake\_default\_role](#module\_snowflake\_default\_role) | getindata/role/snowflake | 3.1.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_credit_quota"></a> [credit\_quota](#output\_credit\_quota) | The number of credits allocated monthly to the resource monitor |
| <a name="output_end_timestamp"></a> [end\_timestamp](#output\_end\_timestamp) | The date and time when the resource monitor suspends the assigned warehouses |
| <a name="output_frequency"></a> [frequency](#output\_frequency) | The frequency interval at which the credit usage resets to 0 |
| <a name="output_name"></a> [name](#output\_name) | Name of resource monitor |
| <a name="output_notify_triggers"></a> [notify\_triggers](#output\_notify\_triggers) | A list of percentage thresholds at which to send an alert to subscribed users |
| <a name="output_notify_users"></a> [notify\_users](#output\_notify\_users) | A list of users to receive email notifications on resource monitors |
| <a name="output_roles"></a> [roles](#output\_roles) | Access roles created for resource monitor |
| <a name="output_start_timestamp"></a> [start\_timestamp](#output\_start\_timestamp) | The date and time when the resource monitor starts monitoring credit usage |
| <a name="output_suspend_immediate_triggers"></a> [suspend\_immediate\_triggers](#output\_suspend\_immediate\_triggers) | A list of percentage thresholds at which to immediately suspend all warehouses |
| <a name="output_suspend_triggers"></a> [suspend\_triggers](#output\_suspend\_triggers) | A list of percentage thresholds at which to suspend all warehouses |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_context"></a> [context](#provider\_context) | >=0.4.0 |
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | >= 0.96 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_context"></a> [context](#requirement\_context) | >=0.4.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 0.96 |

## Resources

| Name | Type |
|------|------|
| [snowflake_resource_monitor.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/resource_monitor) | resource |
| [context_label.this](https://registry.terraform.io/providers/cloudposse/context/latest/docs/data-sources/label) | data source |
<!-- END_TF_DOCS -->

## CONTRIBUTING

Contributions are very welcomed!

Start by reviewing [contribution guide](CONTRIBUTING.md) and our [code of conduct](CODE_OF_CONDUCT.md). After that, start coding and ship your changes by creating a new PR.

## LICENSE

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## AUTHORS

<!--- Replace repository name -->
<a href="https://github.com/getindata/REPO_NAME/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=getindata/terraform-snowflake-resource-monitor" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
