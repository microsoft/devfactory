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
    try(var.catalog.tags, {})
  )
}

resource "azurecaf_name" "catalog" {
  name          = var.catalog.name
  resource_type = "general"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azapi_resource" "catalog" {
  type      = "Microsoft.DevCenter/devcenters/catalogs@2025-04-01-preview"
  name      = azurecaf_name.catalog.result
  parent_id = var.dev_center_id

  # Disable schema validation as the provider validation is overly strict for preview APIs
  schema_validation_enabled = false

  body = {
    properties = merge(
      # GitHub catalog configuration
      try(var.catalog.github, null) != null ? {
        gitHub = {
          branch           = var.catalog.github.branch
          path             = try(var.catalog.github.path, null)
          secretIdentifier = try(var.catalog.github.secret_identifier, null)
          uri              = var.catalog.github.uri
        }
      } : {},

      # Azure DevOps Git catalog configuration
      try(var.catalog.ado_git, null) != null ? {
        adoGit = {
          branch           = var.catalog.ado_git.branch
          path             = try(var.catalog.ado_git.path, null)
          secretIdentifier = try(var.catalog.ado_git.secret_identifier, null)
          uri              = var.catalog.ado_git.uri
        }
      } : {},

      # Sync type configuration
      try(var.catalog.sync_type, null) != null ? {
        syncType = var.catalog.sync_type
      } : {},

      # Resource tags (within properties as per API spec)
      try(var.catalog.resource_tags, null) != null ? {
        tags = var.catalog.resource_tags
      } : {}
    )
  }

  tags = local.tags

  response_export_values = ["properties"]
}
