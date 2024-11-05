context_templates = {
  snowflake-resource-monitor         = "{{.environment}}_{{.name}}"
  snowflake-resource-monitor-role    = "{{.prefix}}_{{.environment}}_{{.resource-monitor}}_{{.name}}"
  snowflake-project-resource-monitor = "{{.environment}}_{{.project}}_{{.name}}"
}
