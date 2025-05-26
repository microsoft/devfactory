# Azure Resource Group Module

This module creates Azure Resource Groups using the AzAPI provider with direct Azure REST API access.

## Overview

The Resource Group module provides a standardized way to create and manage Azure Resource Groups. It leverages the AzAPI provider to ensure access to the latest Azure features and follows DevFactory's standardization patterns for infrastructure as code.

## Features

- Uses AzAPI provider v2.4.0 for latest Azure features
- Implements latest Azure Resource Manager API (2023-07-01)
- Integrates with azurecaf naming conventions
- Manages resource tags (global + specific)
- Provides strong input validation
- Supports location configuration
- Enables flexible resource organization

## Simple Usage

```hcl
module "resource_group" {
  source = "./modules/resource_group"

  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  resource_group = {
    name     = "my-project"
    location = "East US"
    tags = {
      environment = "development"
    }
  }
}
```

## Advanced Usage

```hcl
module "resource_group" {
  source = "./modules/resource_group"

  global_settings = {
    prefixes      = ["prod"]
    random_length = 5
    passthrough   = false
    use_slug      = true
    environment   = "production"
    regions = {
      region1 = "eastus"
      region2 = "westus"
    }
  }

  resource_group = {
    name     = "complex-project"
    location = "East US"
    tags = {
      environment = "production"
      cost_center = "engineering"
      project     = "core-infrastructure"
    }
  }

  tags = {
    managed_by  = "terraform"
    created_by  = "devops-team"
    department  = "infrastructure"
  }
}
```

For more examples, see the [Resource Group examples](../../../examples/resource_group/).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.4.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~> 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.4.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.28 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.resource_group](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.resource_group](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azapi_client_config.current](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object | <pre>object({<br/>    prefixes      = optional(list(string))<br/>    random_length = optional(number)<br/>    passthrough   = optional(bool)<br/>    use_slug      = optional(bool)<br/>  })</pre> | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Configuration object for the resource group | <pre>object({<br/>    name   = string<br/>    region = string<br/>    tags   = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Resource Group |
| <a name="output_location"></a> [location](#output\_location) | The location of the Resource Group |
| <a name="output_name"></a> [name](#output\_name) | The name of the Resource Group |
<!-- END_TF_DOCS -->
