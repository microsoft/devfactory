variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
    tags          = optional(map(string))
  })
}

variable "dev_center_project_id" {
  description = "The ID of the Dev Center Project that will contain the environment type"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/[^/]+/providers/Microsoft\\.DevCenter/projects/[^/]+$", var.dev_center_project_id))
    error_message = "Dev Center Project ID must be a valid Azure resource ID for a Dev Center Project."
  }
}

variable "environment_type_name" {
  description = "The name of the environment type (must match an existing environment type in the Dev Center)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$", var.environment_type_name)) && length(var.environment_type_name) >= 3 && length(var.environment_type_name) <= 128
    error_message = "Environment type name must be between 3 and 128 characters long and can contain alphanumeric characters, periods, hyphens, and underscores. It must start and end with an alphanumeric character."
  }
}

variable "project_environment_type" {
  description = "Configuration object for the Dev Center Project Environment Type"
  type = object({
    status = optional(string, "Enabled")
    user_role_assignments = optional(map(object({
      roles = map(object({}))
    })))
    tags = optional(map(string))
  })

  validation {
    condition     = var.project_environment_type.status == null || contains(["Enabled", "Disabled"], var.project_environment_type.status)
    error_message = "Status must be either 'Enabled' or 'Disabled'."
  }
}