variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = list(string)
    random_length = number
    passthrough   = bool
    use_slug      = bool
  })
  validation {
    condition = (
      length(var.global_settings.prefixes) > 0 &&
      var.global_settings.random_length >= 0
    )
    error_message = "global_settings must have valid prefixes and random_length >= 0."
  }
}

variable "dev_center_id" {
  description = "The ID of the Dev Center in which to create the environment type"
  type        = string
  validation {
    condition     = length(var.dev_center_id) > 0
    error_message = "dev_center_id must be a non-empty string."
  }
}

variable "tags" {
  description = "Optional tags to apply to the environment type. Merged with global and resource-specific tags."
  type        = map(string)
  default     = {}
}

variable "environment_type" {
  description = "Configuration object for the Dev Center Environment Type"
  type = object({
    name         = string
    display_name = optional(string)
    tags         = optional(map(string))
  })
  validation {
    condition     = length(var.environment_type.name) > 0
    error_message = "environment_type.name must be a non-empty string."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,62}$", var.environment_type.name))
    error_message = "environment_type.name must be 3-63 characters long, and can only contain alphanumeric characters, hyphens, underscores, or periods. The name must start with a letter or number."
  }
}