terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4.0"
    }
  }
}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.environment_type.tags, {}),
    try(var.tags, {})
  )
}

resource "azurecaf_name" "environment_type" {
  name          = var.environment_type.name
  resource_type = "general"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azapi_resource" "environment_type" {
  type                   = "Microsoft.DevCenter/devcenters/environmentTypes@2025-04-01-preview"
  name                   = azurecaf_name.environment_type.result
  parent_id              = var.dev_center_id
  tags                   = local.tags
  response_export_values = ["properties.displayName"]

  body = {
    properties = {
      displayName = try(var.environment_type.display_name, var.environment_type.name)
    }
  }
}
