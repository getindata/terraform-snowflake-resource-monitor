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

variable "suspend_triggers" {
  description = "A list of percentage thresholds at which to suspend all warehouses."
  type        = list(number)
  default     = null
}

variable "suspend_immediate_triggers" {
  description = "A list of percentage thresholds at which to immediately suspend all warehouses."
  type        = list(number)
  default     = null
}

variable "notify_users" {
  description = "Specifies the list of users to receive email notifications on resource monitors."
  type        = list(string)
  default     = null
}

variable "set_for_account" {
  description = "Specifies whether the resource monitor should be applied globally to your Snowflake account."
  type        = bool
  default     = true
}

variable "warehouses" {
  description = "A list of warehouse names to apply the resource monitor to."
  type        = list(string)
  default     = null
}

variable "roles" {
  description = "Roles created on the Resource Monitor level"
  type        = any
  default     = {}
}

variable "create_default_roles" {
  description = "Whether the default roles should be created"
  type        = bool
  default     = false
}

variable "descriptor_name" {
  description = "Name of the descriptor used to form a resource name"
  type        = string
  default     = "snowflake-resource-monitor"
}