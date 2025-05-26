# Azure Dev Center Module

This module creates an Azure Dev Center using the AzAPI provider to ensure access to the latest features and API versions.

## Overview

The Dev Center module provides a standardized way to create and manage Azure Dev Centers. It leverages the AzAPI provider to ensure access to the latest Azure features and follows DevFactory's standardization patterns for infrastructure as code.

## Features

- Uses AzAPI provider v2.4.0 for latest Azure features
- Implements latest Azure DevCenter API (2025-04-01-preview)
- Supports multiple identity types (System/User Assigned)
- Configures DevBox provisioning settings
- Manages encryption and network settings
- Handles project catalog configurations
- Integrates with azurecaf naming conventions
- Manages resource tags (global + specific)

## Simple Usage

```hcl
module "dev_center" {
  source = "./modules/dev_center"

  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  dev_center = {
    name = "my-devcenter"
    tags = {
      environment = "development"
      purpose     = "team-development"
    }
  }

  resource_group_name = "my-resource-group"
  location           = "East US"
}
```

## Advanced Usage

```hcl
module "dev_center" {
  source = "./modules/dev_center"

  global_settings = {
    prefixes      = ["prod"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  dev_center = {
    name = "my-devcenter"
    identity = {
      type = "SystemAssigned"
    }
    dev_box_provisioning_settings = {
      install_azure_monitor_agent_enable_installation = "Enabled"
    }
    encryption = {
      key_vault_key = {
        id = "/subscriptions/.../keys/mykey"
      }
    }
    project_catalog_settings = {
      catalog_item_sync_enable_status = "Enabled"
    }
    tags = {
      environment = "production"
      tier        = "premium"
    }
  }

  resource_group_name = "my-resource-group"
  location           = "East US"
}
```

For more examples including all possible configurations, see the [Dev Center examples](../../../examples/dev_center/).

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
| [azapi_resource.dev_center](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.dev_center](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azapi_client_config.current](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_center"></a> [dev\_center](#input\_dev\_center) | Configuration object for the Dev Center | <pre>object({<br/>    name         = string<br/>    display_name = optional(string)<br/>    tags         = optional(map(string))<br/>    identity = optional(object({<br/>      type         = string<br/>      identity_ids = optional(list(string))<br/>    }))<br/>    dev_box_provisioning_settings = optional(object({<br/>      install_azure_monitor_agent_enable_installation = optional(string)<br/>    }))<br/>    encryption = optional(object({<br/>      customer_managed_key_encryption = optional(object({<br/>        key_encryption_key_identity = optional(object({<br/>          identity_type                      = optional(string)<br/>          delegated_identity_client_id       = optional(string)<br/>          user_assigned_identity_resource_id = optional(string)<br/>        }))<br/>        key_encryption_key_url = optional(string)<br/>      }))<br/>    }))<br/>    network_settings = optional(object({<br/>      microsoft_hosted_network_enable_status = optional(string)<br/>    }))<br/>    project_catalog_settings = optional(object({<br/>      catalog_item_sync_enable_status = optional(string)<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object | <pre>object({<br/>    prefixes      = optional(list(string))<br/>    random_length = optional(number)<br/>    passthrough   = optional(bool)<br/>    use_slug      = optional(bool)<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the Dev Center is created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Dev Center | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dev_center_uri"></a> [dev\_center\_uri](#output\_dev\_center\_uri) | The URI of the Dev Center |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Dev Center |
| <a name="output_identity"></a> [identity](#output\_identity) | The identity of the Dev Center |
| <a name="output_location"></a> [location](#output\_location) | The location of the Dev Center |
| <a name="output_name"></a> [name](#output\_name) | The name of the Dev Center |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Dev Center |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name of the Dev Center |
<!-- END_TF_DOCS -->