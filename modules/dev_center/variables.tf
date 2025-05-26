variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
  })
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Dev Center"
  type        = string
}

variable "location" {
  description = "The location/region where the Dev Center is created"
  type        = string
}

variable "dev_center" {
  description = "Configuration object for the Dev Center"
  type = object({
    name         = string
    display_name = optional(string)
    tags         = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    dev_box_provisioning_settings = optional(object({
      install_azure_monitor_agent_enable_installation = optional(string)
    }))
    encryption = optional(object({
      customer_managed_key_encryption = optional(object({
        key_encryption_key_identity = optional(object({
          identity_type                      = optional(string)
          delegated_identity_client_id       = optional(string)
          user_assigned_identity_resource_id = optional(string)
        }))
        key_encryption_key_url = optional(string)
      }))
    }))
    network_settings = optional(object({
      microsoft_hosted_network_enable_status = optional(string)
    }))
    project_catalog_settings = optional(object({
      catalog_item_sync_enable_status = optional(string)
    }))
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$", var.dev_center.name)) && length(var.dev_center.name) >= 3 && length(var.dev_center.name) <= 26
    error_message = "Dev Center name must be between 3 and 26 characters long and can contain alphanumeric characters, periods, hyphens, and underscores. It must start and end with an alphanumeric character."
  }
}
