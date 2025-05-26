# Azure Resource Group Module (AzAPI)

This module creates Azure Resource Groups using the AzAPI provider.

## Overview

This module implements Azure Resource Groups using the AzAPI provider instead of the traditional AzureRM provider. This approach provides access to the latest Azure REST APIs and ensures compatibility with the most recent Azure features.

## Features

- Creates Azure Resource Groups using AzAPI provider v2.4.0
- Supports Azure naming conventions via azurecaf
- Configurable tags support (resource-specific + global)
- Strong typing with validation
- Uses latest Azure REST API version (2023-07-01)
- Follows DevFactory project standards

## Usage

```hcl
module "resource_group" {
  source = "./modules/resource_group"

  global_settings = {
    prefixes      = ["example"]
    random_length = 5
    passthrough   = false
    use_slug      = true
  }

  resource_group = {
    name   = "example-rg"
    region = "East US"
    tags = {
      environment = "dev"
      project     = "example"
    }
  }

  tags = {
    managed_by = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| azurecaf | ~> 1.2.0 |
| azapi | ~> 2.4.0 |

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.0 |
| azapi | ~> 2.4.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.resource_group](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.resource_group](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name) | resource |
| [azapi_client_config.current](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings object for naming conventions | `object({...})` | n/a | yes |
| resource_group | Configuration object for the resource group | `object({...})` | n/a | yes |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Resource Group |
| name | The name of the Resource Group |
| location | The location of the Resource Group |

## API Version

This module uses Azure Resource Manager API version `2023-07-01` for resource groups, which is the latest stable version as of 2025.

## Example

For a complete example, see the [simple case example](../../../examples/resource_group/simple_case/configuration.tfvars).
