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

resource "azurecaf_name" "dev_box_definition" {
  name          = var.dev_box_definition.name
  resource_type = "general"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_dev_center_dev_box_definition" "dev_box_definition" {
  name               = azurecaf_name.dev_box_definition.result
  location           = var.location
  dev_center_id      = var.dev_center_id
  image_reference_id = var.dev_box_definition.image_reference_id != null ? "${var.dev_center_id}${var.dev_box_definition.image_reference_id}" : null
  sku_name           = try(var.dev_box_definition.sku_name, null)
  tags               = try(var.tags, null)
}