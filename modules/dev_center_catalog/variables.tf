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

variable "dev_center_id" {
  description = "The resource ID of the parent Dev Center"
  type        = string
  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.DevCenter/devcenters/[^/]+$", var.dev_center_id))
    error_message = "dev_center_id must be a valid Dev Center resource ID."
  }
}

variable "catalog" {
  description = "Configuration object for the Dev Center Catalog"
  type = object({
    name = string
    tags = optional(map(string))

    # GitHub catalog configuration
    github = optional(object({
      branch            = string
      uri               = string
      path              = optional(string)
      secret_identifier = optional(string)
    }))

    # Azure DevOps Git catalog configuration
    ado_git = optional(object({
      branch            = string
      uri               = string
      path              = optional(string)
      secret_identifier = optional(string)
    }))

    # Sync type: Manual or Scheduled
    sync_type = optional(string)

    # Resource-specific tags (separate from infrastructure tags)
    resource_tags = optional(map(string))
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,62}$", var.catalog.name)) && length(var.catalog.name) >= 3 && length(var.catalog.name) <= 63
    error_message = "Catalog name must be between 3 and 63 characters long and match the pattern ^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,62}$."
  }

  validation {
    condition     = try(var.catalog.sync_type, null) == null ? true : contains(["Manual", "Scheduled"], var.catalog.sync_type)
    error_message = "sync_type must be either 'Manual' or 'Scheduled'."
  }

  validation {
    condition = (
      try(var.catalog.github, null) != null && try(var.catalog.ado_git, null) == null
      ) || (
      try(var.catalog.github, null) == null && try(var.catalog.ado_git, null) != null
    )
    error_message = "Exactly one of 'github' or 'ado_git' must be specified, but not both."
  }
}
