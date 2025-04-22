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
    name = string
    resource_group = object({
      key = string
    })
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
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

# tflint-ignore: terraform_unused_declarations
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
    image_reference_id = string
    sku_name           = string
    hibernate_support = optional(object({
      enabled = optional(bool, false)
    }))
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
    region                     = optional(string)
    description                = optional(string)
    maximum_dev_boxes_per_user = optional(number)
    dev_box_definition_names   = optional(list(string), [])
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
      }), {
      type = "SystemAssigned"
    })
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "dev_center_environment_types" {
  description = "Dev Center Environment Types configuration objects"
  type = map(object({
    name          = string
    dev_center_id = optional(string)
    dev_center = optional(object({
      key = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

# tflint-ignore: terraform_unused_declarations
variable "dev_center_project_environment_types" {
  description = "Dev Center Project Environment Types configuration objects"
  type = map(object({
    name       = string
    project_id = optional(string)
    project = optional(object({
      key = string
    }))
    environment_type_id = optional(string)
    environment_type = optional(object({
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
    name          = string
    dev_center_id = optional(string)
    dev_center = optional(object({
      key = string
    }))
    network_connection_resource_id = string
    subnet_resource_id             = string
    domain_join = optional(object({
      domain_name               = string
      domain_password_secret_id = optional(string)
      domain_username           = string
      organizational_unit_path  = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

# tflint-ignore: terraform_unused_declarations
variable "dev_center_catalogs" {
  description = "Dev Center Catalogs configuration objects"
  type = map(object({
    name          = string
    description   = optional(string)
    dev_center_id = optional(string)
    dev_center = optional(object({
      key = string
    }))
    resource_group_name = optional(string)
    resource_group = optional(object({
      key = string
    }))
    catalog_github = optional(object({
      branch            = string
      path              = string
      key_vault_key_url = string
      uri               = string
    }))
    catalog_adogit = optional(object({
      branch            = string
      path              = string
      key_vault_key_url = string
      uri               = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
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
