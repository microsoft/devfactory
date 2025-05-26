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

data "azapi_client_config" "current" {}

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

resource "azapi_resource" "resource_group" {
  name      = azurecaf_name.resource_group.result
  location  = var.resource_group.region
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2023-07-01"
  tags      = local.tags

  body = {
    properties = {}
  }

  response_export_values = ["*"]
}
