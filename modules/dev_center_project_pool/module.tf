# DevCenter Project Pool Module
# This module creates Azure DevCenter project pools using the AzAPI provider
# Following Microsoft.DevCenter/projects/pools@2025-04-01-preview schema

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
  }
}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.pool.tags, {}),
    {
      terraform-azapi-resource-type = "Microsoft.DevCenter/projects/pools"
      terraform-azapi-version       = "2025-04-01-preview"
    }
  )
}

resource "azurecaf_name" "project_pool" {
  name          = var.pool.name
  resource_type = "azurerm_dev_center_project"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

# DevCenter Project Pool Resource
resource "azapi_resource" "dev_center_project_pool" {
  type      = "Microsoft.DevCenter/projects/pools@2025-04-01-preview"
  name      = azurecaf_name.project_pool.result
  parent_id = var.dev_center_project_id
  location  = var.location

  body = {
    properties = {
      devBoxDefinitionName = var.pool.dev_box_definition_name
      displayName          = try(var.pool.display_name, var.pool.name)

      # Local administrator settings
      localAdministrator = try(var.pool.local_administrator_enabled, false) ? "Enabled" : "Disabled"

      # Network connection (use "default" for Microsoft-hosted network)
      networkConnectionName = try(var.pool.network_connection_name, "default")

      # Stop on disconnect settings
      stopOnDisconnect = {
        status             = "Enabled"
        gracePeriodMinutes = try(var.pool.stop_on_disconnect_grace_period_minutes, 60)
      }

      # Licensing type (required property)
      licenseType = try(var.pool.license_type, "Windows_Client")

      # Virtual network type and regions for managed networks
      virtualNetworkType           = try(var.pool.virtual_network_type, "Managed")
      managedVirtualNetworkRegions = [var.location]
    }
  }

  # Conditional tags - merge global tags with resource-specific tags
  tags = local.tags

  # Ignore changes to certain computed properties and Azure-managed tags
  lifecycle {
    ignore_changes = [
      body.properties.healthStatus,
      body.properties.provisioningState,
      tags["hidden-title"]
    ]
  }
}


