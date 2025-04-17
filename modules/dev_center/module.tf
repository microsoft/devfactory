terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.dev_center.tags, {})
  )
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

resource "azurerm_dev_center" "dev_center" {
  name                = azurecaf_name.dev_center.result
  location            = var.location
  resource_group_name = var.resource_group_name

  # Optional identity block - only include if specified in config
  dynamic "identity" {
    for_each = try(var.dev_center.identity, null) != null ? [1] : []
    content {
      type         = try(var.dev_center.identity.type, "SystemAssigned")
      identity_ids = try(var.dev_center.identity.identity_ids, null)
    }
  }

  tags = local.tags
}
