# Azure DevCenter Project Module

This module creates an Azure DevCenter Project using the AzAPI provider with direct Azure REST API access.

## Overview

The DevCenter Project module enables the creation and management of projects within Azure DevCenter. It leverages the AzAPI provider to access the latest Azure features and follows DevFactory's standardization patterns for infrastructure as code.

## Features

- Uses AzAPI provider v2.4.0 for latest Azure features
- Implements latest Azure DevCenter API (2025-04-01-preview)
- Supports identity management (System/User Assigned)
- Integrates with Azure AI services
- Manages catalog synchronization
- Controls user customization capabilities
- Configures auto-deletion policies
- Supports serverless GPU sessions
- Handles workspace storage configuration
- Integrates with azurecaf naming conventions
- Manages resource tags (global + specific)

## Simple Usage

```hcl
module "dev_center_project" {
  source = "./modules/dev_center_project"

  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  project = {
    name                       = "myproject"
    description               = "Development project for engineering team"
    maximum_dev_boxes_per_user = 3
  }

  dev_center_id     = "/subscriptions/.../devcenters/mydevcenter"
  resource_group_id = "/subscriptions/.../resourceGroups/myrg"
  location          = "East US"
}
```

## Advanced Usage

```hcl
module "dev_center_project" {
  source = "./modules/dev_center_project"

  global_settings = {
    prefixes      = ["prod"]
    random_length = 5
    passthrough   = false
    use_slug      = true
  }

  project = {
    name                       = "ai-development"
    description               = "AI/ML development project with GPU support"
    display_name              = "AI Development Project"
    maximum_dev_boxes_per_user = 5

    identity = {
      type = "SystemAssigned"
    }

    azure_ai_services_settings = {
      azure_ai_services_mode = "AutoDeploy"
    }

    catalog_settings = {
      catalog_item_sync_types = ["EnvironmentDefinition", "ImageDefinition"]
    }

    customization_settings = {
      user_customizations_enable_status = "Enabled"
    }

    dev_box_auto_delete_settings = {
      delete_mode        = "Auto"
      grace_period       = "PT24H"
      inactive_threshold = "PT72H"
    }

    serverless_gpu_sessions_settings = {
      max_concurrent_sessions_per_project = 10
    }
  }

  dev_center_id     = "/subscriptions/.../devcenters/mydevcenter"
  resource_group_id = "/subscriptions/.../resourceGroups/myrg"
  location          = "East US"

  tags = {
    environment = "production"
    cost_center = "engineering"
  }
}
```

For more examples, see the [Dev Center Project examples](../../../examples/dev_center_project/).

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
| [azapi_resource.project](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.project](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_center_id"></a> [dev\_center\_id](#input\_dev\_center\_id) | The ID of the Dev Center in which to create the project | `string` | n/a | yes |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object | <pre>object({<br/>    prefixes      = optional(list(string))<br/>    random_length = optional(number)<br/>    passthrough   = optional(bool)<br/>    use_slug      = optional(bool)<br/>    tags          = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the Dev Center Project is created | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Configuration object for the Dev Center Project | <pre>object({<br/>    name                       = string<br/>    description                = optional(string)<br/>    display_name               = optional(string)<br/>    maximum_dev_boxes_per_user = optional(number)<br/>    tags                       = optional(map(string), {})<br/><br/>    # Managed Identity configuration<br/>    identity = optional(object({<br/>      type         = string # "None", "SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"<br/>      identity_ids = optional(list(string), [])<br/>    }))<br/><br/>    # Azure AI Services Settings<br/>    azure_ai_services_settings = optional(object({<br/>      azure_ai_services_mode = optional(string, "Disabled") # "AutoDeploy", "Disabled"<br/>    }))<br/><br/>    # Catalog Settings<br/>    catalog_settings = optional(object({<br/>      catalog_item_sync_types = optional(list(string), []) # "EnvironmentDefinition", "ImageDefinition"<br/>    }))<br/><br/>    # Customization Settings<br/>    customization_settings = optional(object({<br/>      user_customizations_enable_status = optional(string, "Disabled") # "Enabled", "Disabled"<br/>      identities = optional(list(object({<br/>        identity_resource_id = optional(string)<br/>        identity_type        = optional(string) # "systemAssignedIdentity", "userAssignedIdentity"<br/>      })), [])<br/>    }))<br/><br/>    # Dev Box Auto Delete Settings<br/>    dev_box_auto_delete_settings = optional(object({<br/>      delete_mode        = optional(string, "Manual") # "Auto", "Manual"<br/>      grace_period       = optional(string)           # ISO8601 duration format PT[n]H[n]M[n]S<br/>      inactive_threshold = optional(string)           # ISO8601 duration format PT[n]H[n]M[n]S<br/>    }))<br/><br/>    # Serverless GPU Sessions Settings<br/>    serverless_gpu_sessions_settings = optional(object({<br/>      max_concurrent_sessions_per_project = optional(number)<br/>      serverless_gpu_sessions_mode        = optional(string, "Disabled") # "AutoDeploy", "Disabled"<br/>    }))<br/><br/>    # Workspace Storage Settings<br/>    workspace_storage_settings = optional(object({<br/>      workspace_storage_mode = optional(string, "Disabled") # "AutoDeploy", "Disabled"<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the resource group in which to create the Dev Center Project | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dev_center_id"></a> [dev\_center\_id](#output\_dev\_center\_id) | The ID of the Dev Center resource this project is associated with |
| <a name="output_dev_center_uri"></a> [dev\_center\_uri](#output\_dev\_center\_uri) | The URI of the Dev Center resource this project is associated with |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Dev Center Project |
| <a name="output_identity"></a> [identity](#output\_identity) | The managed identity of the Dev Center Project |
| <a name="output_location"></a> [location](#output\_location) | The location of the Dev Center Project |
| <a name="output_name"></a> [name](#output\_name) | The name of the Dev Center Project |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Dev Center Project |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the Dev Center Project |
<!-- END_TF_DOCS -->