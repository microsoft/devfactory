variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
    tags          = optional(map(string))
    regions       = optional(map(string)) # Ensure downstream modules accept this field
  })
}

variable "resource_groups" {
  description = "Resource groups configuration objects"
  type = map(object({
    name   = string
    region = string
    tags   = optional(map(string), {})
  }))
  default = {}
}

variable "dev_centers" {
  description = "Dev Centers configuration objects"
  type = map(object({
    name         = string
    display_name = optional(string)
    resource_group = object({
      key = string
    })
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
    tags = optional(map(string), {})
  }))
  default = {}
}

#tflint-ignore: terraform_unused_declarations
variable "dev_center_galleries" {
  description = "Dev Center Galleries configuration objects"
  type = map(object({
    name          = string
    dev_center_id = optional(string)
    dev_center = optional(object({
      key = string
    }))
    resource_group_name = optional(string)
    resource_group = optional(object({
      key = string
    }))
    gallery_resource_id = string
    shared_gallery = optional(object({
      key = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "dev_center_dev_box_definitions" {
  description = "Dev Center Dev Box Definitions configuration objects"
  type = map(object({
    name = string
    dev_center = object({
      key = string
    })
    resource_group = object({
      key = string
    })

    # Image reference - supports both direct ID and object form
    image_reference_id = optional(string)
    image_reference = optional(object({
      id = string
    }))

    # SKU configuration - supports both simple name and full object
    sku_name = optional(string)
    sku = optional(object({
      name     = string
      capacity = optional(number)
      family   = optional(string)
      size     = optional(string)
      tier     = optional(string) # Free, Basic, Standard, Premium
    }))

    # OS Storage type for the Operating System disk
    os_storage_type = optional(string)

    # Hibernate support
    hibernate_support = optional(bool, false)

    # Tags
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "dev_center_projects" {
  description = "Dev Center Projects configuration objects"
  type = map(object({
    name          = string
    dev_center_id = optional(string)
    dev_center = optional(object({
      key = string
    }))
    resource_group_name = optional(string)
    resource_group = optional(object({
      key = string
    }))
    resource_group_id          = optional(string)
    region                     = optional(string)
    description                = optional(string)
    display_name               = optional(string)
    maximum_dev_boxes_per_user = optional(number)
    dev_box_definition_names   = optional(list(string), [])

    # Managed Identity configuration
    identity = optional(object({
      type         = string # "None", "SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"
      identity_ids = optional(list(string), [])
      }), {
      type = "SystemAssigned"
    })

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

    tags = optional(map(string), {})
  }))
  default = {}
}

variable "dev_center_catalogs" {
  description = "Dev Center Catalogs configuration objects"
  type = map(object({
    name          = string
    dev_center_id = optional(string)
    dev_center = optional(object({
      key = string
    }))

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

    tags = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.dev_center_catalogs : (
        (try(v.github, null) != null && try(v.ado_git, null) == null) ||
        (try(v.github, null) == null && try(v.ado_git, null) != null)
      )
    ])
    error_message = "Each catalog must specify exactly one of 'github' or 'ado_git', but not both."
  }

  validation {
    condition = alltrue([
      for k, v in var.dev_center_catalogs :
      try(v.sync_type, null) == null ? true : contains(["Manual", "Scheduled"], v.sync_type)
    ])
    error_message = "sync_type must be either 'Manual' or 'Scheduled'."
  }
}

variable "dev_center_environment_types" {
  description = "Dev Center Environment Types configuration objects"
  type = map(object({
    name          = string
    display_name  = optional(string)
    dev_center_id = optional(string)
    dev_center = optional(object({
      key = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

# tflint-ignore: terraform_unused_declarations
variable "dev_center_network_connections" {
  description = "Dev Center Network Connections configuration objects"
  type = map(object({
    name             = string
    domain_join_type = string
    subnet_id        = string
    dev_center_id    = optional(string)
    dev_center = optional(object({
      key = string
    }))
    resource_group = optional(object({
      key = string
    }))
    domain_join = optional(object({
      domain_name               = string
      domain_password_secret_id = optional(string)
      domain_username           = string
      organizational_unit_path  = optional(string)
    }))
    networking_resource_group_name = optional(string)
    tags                           = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.dev_center_network_connections :
      contains(["AzureADJoin", "HybridAzureADJoin", "None"], v.domain_join_type)
    ])
    error_message = "Domain join type must be one of: AzureADJoin, HybridAzureADJoin, None."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "shared_image_galleries" {
  description = "Shared Image Galleries configuration objects"
  type = map(object({
    name                = string
    description         = optional(string)
    location            = optional(string)
    resource_group_name = optional(string)
    resource_group = optional(object({
      key = string
    }))
    sharing = optional(object({
      permission = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "dev_center_project_pools" {
  description = "DevCenter Project Pools configuration objects"
  type = map(object({
    name                    = string
    display_name            = optional(string)
    dev_box_definition_name = string
    dev_center_project_id   = optional(string)
    dev_center_project = optional(object({
      key = string
    }))
    resource_group_id = optional(string)
    resource_group = optional(object({
      key = string
    }))
    region                                  = optional(string)
    local_administrator_enabled             = optional(bool, false)
    network_connection_name                 = optional(string, "default")
    stop_on_disconnect_grace_period_minutes = optional(number, 60)
    license_type                            = optional(string, "Windows_Client")
    virtual_network_type                    = optional(string, "Managed")
    single_sign_on_status                   = optional(string, "Disabled")
    tags                                    = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for pool_key, pool in var.dev_center_project_pools :
      pool.stop_on_disconnect_grace_period_minutes >= 60 && pool.stop_on_disconnect_grace_period_minutes <= 480
    ])
    error_message = "Stop on disconnect grace period must be between 60 and 480 minutes for all pools."
  }
}

variable "dev_center_project_pool_schedules" {
  description = "DevCenter Project Pool Schedules configuration objects"
  type = map(object({
    dev_center_project_pool_id = optional(string)
    dev_center_project_pool = optional(object({
      key = string
    }))
    schedule = object({
      name      = string
      type      = optional(string, "StopDevBox")
      frequency = optional(string, "Daily")
      time      = string
      time_zone = string
      state     = optional(string, "Enabled")
      tags      = optional(map(string), {})
    })
  }))
  default = {}
}

variable "dev_center_project_environment_types" {
  description = "Dev Center Project Environment Types configuration objects"
  type = map(object({
    name = string
    project = object({
      key = string
    })
    environment_type = object({
      key = string
    })
    dev_center_project_id = optional(string)
    deployment_target_id  = optional(string)
    status                = optional(string, "Enabled")
    user_role_assignments = optional(map(object({
      roles = map(object({}))
    })))
    tags = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.dev_center_project_environment_types : (
        (v.dev_center_project_id != null && v.project == null) ||
        (v.dev_center_project_id == null && v.project != null)
      )
    ])
    error_message = "Either 'dev_center_project_id' or 'project.key' must be specified, but not both."
  }

  validation {
    condition = alltrue([
      for k, v in var.dev_center_project_environment_types : (
        (v.deployment_target_id != null && v.environment_type == null) ||
        (v.deployment_target_id == null && v.environment_type != null)
      )
    ])
    error_message = "Either 'deployment_target_id' or 'environment_type.key' must be specified, but not both."
  }

  validation {
    condition = alltrue([
      for k, v in var.dev_center_project_environment_types :
      contains(["Enabled", "Disabled"], v.status)
    ])
    error_message = "Status must be either 'Enabled' or 'Disabled'."
  }
}
