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


locals {}

resource "azurecaf_name" "project" {
  name          = var.project.name
  resource_type = "general"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_dev_center_project" "project" {
  name                       = azurecaf_name.project.result
  resource_group_name        = var.resource_group_name
  location                   = var.location
  dev_center_id              = var.dev_center_id
  description                = try(var.project.description, null)
  maximum_dev_boxes_per_user = try(var.project.maximum_dev_boxes_per_user, null)
  tags                       = try(var.tags, null)
}
