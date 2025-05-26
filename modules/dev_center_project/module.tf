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
  tags = merge(var.global_settings.tags, var.tags, var.project.tags)
}

resource "azurecaf_name" "project" {
  name          = var.project.name
  resource_type = "general"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azapi_resource" "project" {
  type                      = "Microsoft.DevCenter/projects@2025-04-01-preview"
  name                      = azurecaf_name.project.result
  location                  = var.location
  parent_id                 = var.resource_group_id
  tags                      = local.tags
  response_export_values    = ["properties.provisioningState", "properties.devCenterUri"]
  schema_validation_enabled = true

  dynamic "identity" {
    for_each = try(var.project.identity, null) != null ? [var.project.identity] : []
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, [])
    }
  }

  body = {
    properties = {
      devCenterId        = var.dev_center_id
      description        = try(var.project.description, null)
      displayName        = try(var.project.display_name, null)
      maxDevBoxesPerUser = try(var.project.maximum_dev_boxes_per_user, null)

      # Azure AI Services Settings
      azureAiServicesSettings = try(var.project.azure_ai_services_settings, null) != null ? {
        azureAiServicesMode = try(var.project.azure_ai_services_settings.azure_ai_services_mode, "Disabled")
      } : null

      # Catalog Settings
      catalogSettings = try(var.project.catalog_settings, null) != null ? {
        catalogItemSyncTypes = try(var.project.catalog_settings.catalog_item_sync_types, [])
      } : null

      # Customization Settings
      customizationSettings = try(var.project.customization_settings, null) != null ? {
        userCustomizationsEnableStatus = try(var.project.customization_settings.user_customizations_enable_status, "Disabled")
        identities = try(var.project.customization_settings.identities, null) != null ? [
          for identity in var.project.customization_settings.identities : {
            identityResourceId = try(identity.identity_resource_id, null)
            identityType       = try(identity.identity_type, null)
          }
        ] : []
      } : null

      # Dev Box Auto Delete Settings
      devBoxAutoDeleteSettings = try(var.project.dev_box_auto_delete_settings, null) != null ? {
        deleteMode        = try(var.project.dev_box_auto_delete_settings.delete_mode, "Manual")
        gracePeriod       = try(var.project.dev_box_auto_delete_settings.grace_period, null)
        inactiveThreshold = try(var.project.dev_box_auto_delete_settings.inactive_threshold, null)
      } : null

      # Serverless GPU Sessions Settings
      serverlessGpuSessionsSettings = try(var.project.serverless_gpu_sessions_settings, null) != null ? {
        maxConcurrentSessionsPerProject = try(var.project.serverless_gpu_sessions_settings.max_concurrent_sessions_per_project, null)
        serverlessGpuSessionsMode       = try(var.project.serverless_gpu_sessions_settings.serverless_gpu_sessions_mode, "Disabled")
      } : null

      # Workspace Storage Settings
      workspaceStorageSettings = try(var.project.workspace_storage_settings, null) != null ? {
        workspaceStorageMode = try(var.project.workspace_storage_settings.workspace_storage_mode, "Disabled")
      } : null
    }
  }
}
