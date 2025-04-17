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
    var.tags,
    var.resource_group.tags,
    {
      "resource_type" = "Resource Group"
    }
  )
}

resource "azurecaf_name" "resource_group" {
  name          = var.resource_group.name
  resource_type = "azurerm_resource_group"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_resource_group" "resource_group" {
  name     = azurecaf_name.resource_group.result
  location = var.resource_group.region
  tags     = local.tags
}
