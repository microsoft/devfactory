# DevCenter Project Pool Module Variables

variable "global_settings" {
  description = "Global settings for the module"
  type = object({
    prefixes      = optional(list(string), [])
    random_length = optional(number, 0)
    passthrough   = optional(bool, false)
    use_slug      = optional(bool, true)
    tags          = optional(map(string), {})
  })
  default = {}
}

variable "pool" {
  description = "DevCenter project pool configuration"
  type = object({
    name                                    = string
    display_name                            = optional(string)
    dev_box_definition_name                 = string
    local_administrator_enabled             = optional(bool, false)
    network_connection_name                 = optional(string, "default")
    stop_on_disconnect_grace_period_minutes = optional(number, 60)
    license_type                            = optional(string, "Windows_Client")
    virtual_network_type                    = optional(string, "Managed")
    managed_virtual_network_regions         = optional(list(string))
    single_sign_on_status                   = optional(string, "Disabled")
    tags                                    = optional(map(string), {})
  })

  validation {
    condition     = var.pool.stop_on_disconnect_grace_period_minutes >= 60 && var.pool.stop_on_disconnect_grace_period_minutes <= 480
    error_message = "Stop on disconnect grace period must be between 60 and 480 minutes."
  }

  validation {
    condition     = contains(["Windows_Client", "Windows_Server"], var.pool.license_type)
    error_message = "License type must be either 'Windows_Client' or 'Windows_Server'."
  }

  validation {
    condition     = contains(["Managed", "Unmanaged"], var.pool.virtual_network_type)
    error_message = "Virtual network type must be either 'Managed' or 'Unmanaged'."
  }

  validation {
    condition     = contains(["Enabled", "Disabled"], var.pool.single_sign_on_status)
    error_message = "Single sign-on status must be either 'Enabled' or 'Disabled'."
  }
}

variable "dev_center_project_id" {
  description = "The ID of the DevCenter project that will contain this pool"
  type        = string
}

variable "location" {
  description = "The Azure region where the pool will be deployed"
  type        = string
}

#tflint-ignore: terraform_unused_declarations
variable "resource_group_id" {
  description = "The ID of the resource group"
  type        = string
}
