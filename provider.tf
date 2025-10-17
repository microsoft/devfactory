terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.7.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.29"
    }
  }
  required_version = ">= 1.12.1"
}
