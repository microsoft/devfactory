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
    try(var.dev_center.tags, {})
  )

  # Ensure DevCenter name is 26 characters or less
  dev_center_name = substr(azurecaf_name.dev_center.result, 0, 26)
}

# Using resource instead of data source to ensure stable naming across plan/apply
resource "azurecaf_name" "dev_center" {
  name          = var.dev_center.name
  resource_type = "general"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azapi_resource" "dev_center" {
  type      = "Microsoft.DevCenter/devcenters@2025-04-01-preview"
  name      = local.dev_center_name
  location  = var.location
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"

  # Identity configuration - only included when identity is specified
  dynamic "identity" {
    for_each = try(var.dev_center.identity, null) != null ? [var.dev_center.identity] : []
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  body = {
    properties = merge(
      try(var.dev_center.display_name, null) != null ? {
        displayName = var.dev_center.display_name
      } : {},
      try(var.dev_center.dev_box_provisioning_settings, null) != null ? {
        devBoxProvisioningSettings = {
          installAzureMonitorAgentEnableStatus = try(var.dev_center.dev_box_provisioning_settings.install_azure_monitor_agent_enable_installation, null)
        }
      } : {},
      try(var.dev_center.encryption, null) != null ? {
        encryption = var.dev_center.encryption
      } : {},
      try(var.dev_center.network_settings, null) != null ? {
        networkSettings = {
          microsoftHostedNetworkEnableStatus = try(var.dev_center.network_settings.microsoft_hosted_network_enable_status, null)
        }
      } : {},
      try(var.dev_center.project_catalog_settings, null) != null ? {
        projectCatalogSettings = {
          catalogItemSyncEnableStatus = try(var.dev_center.project_catalog_settings.catalog_item_sync_enable_status, null)
        }
      } : {}
    )
  }

  tags = local.tags

  response_export_values = ["properties"]
}

data "azapi_client_config" "current" {}