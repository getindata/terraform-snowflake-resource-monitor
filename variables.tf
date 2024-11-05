variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "credit_quota" {
  description = "The number of credits allocated monthly to the resource monitor."
  type        = number
  default     = null
}

variable "frequency" {
  description = "The frequency interval at which the credit usage resets to 0. If you set a frequency for a resource monitor, you must also set START_TIMESTAMP."
  type        = string
  default     = null
  validation {
    condition     = var.frequency == null || contains(["NEVER", "YEARLY", "MONTHLY", "WEEKLY", "DAILY"], coalesce(var.frequency, "null"))
    error_message = "The value of frequency must be one of 'NEVER', 'YEARLY', 'MONTHLY', 'WEEKLY', 'DAILY'."
  }
}

variable "start_timestamp" {
  description = " The date and time when the resource monitor starts monitoring credit usage for the assigned warehouses."
  type        = string
  default     = null
}

variable "end_timestamp" {
  description = "The date and time when the resource monitor suspends the assigned warehouses."
  type        = string
  default     = null
}

variable "notify_triggers" {
  description = "A list of percentage thresholds at which to send an alert to subscribed users."
  type        = list(number)
  default     = null
}

variable "suspend_trigger" {
  description = "The number that represents the percentage threshold at which to suspend all warehouses."
  type        = number
  default     = null
}

variable "suspend_immediate_trigger" {
  description = "The number that represents the percentage threshold at which to immediately suspend all warehouses."
  type        = number
  default     = null
}

variable "notify_users" {
  description = "Specifies the list of users to receive email notifications on resource monitors."
  type        = list(string)
  default     = null
}

variable "roles" {
  description = "Roles created on the Resource Monitor level"
  type = map(object({
    name_scheme = optional(object({
      properties            = optional(list(string))
      delimiter             = optional(string)
      context_template_name = optional(string)
      replace_chars_regex   = optional(string)
      extra_labels          = optional(map(string))
    }))
    comment              = optional(string)
    role_ownership_grant = optional(string)
    granted_roles        = optional(list(string))
    granted_to_roles     = optional(list(string))
    granted_to_users     = optional(list(string))
    resource_monitor_grants = optional(object({
      all_privileges    = optional(bool)
      with_grant_option = optional(bool, false)
      privileges        = optional(list(string))
    }))
  }))
  default = {}
}

variable "create_default_roles" {
  description = "Whether the default roles should be created"
  type        = bool
  default     = false
}

variable "name_scheme" {
  description = <<EOT
  Naming scheme configuration for the resource. This configuration is used to generate names using context provider:
    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`
    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`
    - `context_template_name` - name of the context template used to create the name
    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name
    - `extra_values` - map of extra label-value pairs, used to create a name
  EOT
  type = object({
    properties            = optional(list(string), ["environment", "name"])
    delimiter             = optional(string, "_")
    context_template_name = optional(string, "snowflake-resource-monitor")
    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")
    extra_values          = optional(map(string))
  })
  default = {}
}

variable "context_templates" {
  description = "Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration"
  type        = map(string)
  default     = {}
}
