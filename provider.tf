terraform {
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
  required_version = ">= 1.12.1"
}
