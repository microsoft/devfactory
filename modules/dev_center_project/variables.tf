variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
    tags          = optional(map(string), {})
  })
}

variable "dev_center_id" {
  description = "The ID of the Dev Center in which to create the project"
  type        = string
}

variable "location" {
  description = "The location/region where the Dev Center Project is created"
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group in which to create the Dev Center Project"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Configuration object for the Dev Center Project"
  type = object({
    name                       = string
    description                = optional(string)
    display_name               = optional(string)
    maximum_dev_boxes_per_user = optional(number)
    tags                       = optional(map(string), {})

    # Managed Identity configuration
    identity = optional(object({
      type         = string # "None", "SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"
      identity_ids = optional(list(string), [])
    }))

    # Azure AI Services Settings
    azure_ai_services_settings = optional(object({
      azure_ai_services_mode = optional(string, "Disabled") # "AutoDeploy", "Disabled"
    }))

    # Catalog Settings
    catalog_settings = optional(object({
      catalog_item_sync_types = optional(list(string), []) # "EnvironmentDefinition", "ImageDefinition"
    }))

    # Customization Settings
    customization_settings = optional(object({
      user_customizations_enable_status = optional(string, "Disabled") # "Enabled", "Disabled"
      identities = optional(list(object({
        identity_resource_id = optional(string)
        identity_type        = optional(string) # "systemAssignedIdentity", "userAssignedIdentity"
      })), [])
    }))

    # Dev Box Auto Delete Settings
    dev_box_auto_delete_settings = optional(object({
      delete_mode        = optional(string, "Manual") # "Auto", "Manual"
      grace_period       = optional(string)           # ISO8601 duration format PT[n]H[n]M[n]S
      inactive_threshold = optional(string)           # ISO8601 duration format PT[n]H[n]M[n]S
    }))

    # Serverless GPU Sessions Settings
    serverless_gpu_sessions_settings = optional(object({
      max_concurrent_sessions_per_project = optional(number)
      serverless_gpu_sessions_mode        = optional(string, "Disabled") # "AutoDeploy", "Disabled"
    }))

    # Workspace Storage Settings
    workspace_storage_settings = optional(object({
      workspace_storage_mode = optional(string, "Disabled") # "AutoDeploy", "Disabled"
    }))
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,62}$", var.project.name))
    error_message = "Project name must be 3-63 characters long and match pattern ^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,62}$."
  }

  validation {
    condition     = var.project.maximum_dev_boxes_per_user == null || var.project.maximum_dev_boxes_per_user >= 0
    error_message = "Maximum dev boxes per user must be 0 or greater."
  }

  validation {
    condition     = var.project.identity == null || contains(["None", "SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.project.identity.type)
    error_message = "Identity type must be one of: None, SystemAssigned, UserAssigned, or 'SystemAssigned, UserAssigned'."
  }
}
