# Azure DevCenter Project Module

This module creates an Azure DevCenter Project using the AzAPI provider with the latest 2025-04-01-preview API version.

## Features

- **Complete API Coverage**: Supports all features available in the latest Azure DevCenter Projects API
- **Identity Management**: System-assigned and user-assigned managed identities
- **Azure AI Services**: Integration with Azure AI services for development workflows
- **Catalog Management**: Synchronization of environment and image definitions
- **User Customizations**: Control over user customization capabilities
- **Auto-Delete Settings**: Cost management through automatic Dev Box deletion
- **Serverless GPU**: Support for serverless GPU sessions for AI workloads
- **Workspace Storage**: Configurable workspace storage modes
- **Strong Typing**: Comprehensive input validation and type safety
- **Naming Convention**: Integrated with azurecaf for consistent naming

## Usage

### Basic Example

```hcl
module "dev_center_project" {
  source = "./modules/dev_center_project"

  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
    tags = {
      environment = "demo"
    }
  }

  project = {
    name                       = "myproject"
    description                = "Development project for engineering team"
    maximum_dev_boxes_per_user = 3
  }

  dev_center_id     = "/subscriptions/.../devcenters/mydevcenter"
  resource_group_id = "/subscriptions/.../resourceGroups/myrg"
  location          = "East US"
}
```

### Advanced Example with All Features

```hcl
module "dev_center_project" {
  source = "./modules/dev_center_project"

  global_settings = {
    prefixes      = ["prod"]
    random_length = 5
    passthrough   = false
    use_slug      = true
    tags = {
      environment = "production"
      cost_center = "engineering"
    }
  }

  project = {
    name                       = "ai-development-project"
    description                = "AI/ML development project with GPU support"
    display_name               = "AI Development Project"
    maximum_dev_boxes_per_user = 5

    # System-assigned managed identity
    identity = {
      type = "SystemAssigned"
    }

    # Enable Azure AI services
    azure_ai_services_settings = {
      azure_ai_services_mode = "AutoDeploy"
    }

    # Sync both environment and image definitions
    catalog_settings = {
      catalog_item_sync_types = ["EnvironmentDefinition", "ImageDefinition"]
    }

    # Enable user customizations
    customization_settings = {
      user_customizations_enable_status = "Enabled"
    }

    # Auto-delete for cost optimization
    dev_box_auto_delete_settings = {
      delete_mode        = "Auto"
      grace_period       = "PT24H"  # 24 hours
      inactive_threshold = "PT72H"  # 72 hours
    }

    # Serverless GPU for AI workloads
    serverless_gpu_sessions_settings = {
      max_concurrent_sessions_per_project = 10
      serverless_gpu_sessions_mode        = "AutoDeploy"
    }

    # Auto-deploy workspace storage
    workspace_storage_settings = {
      workspace_storage_mode = "AutoDeploy"
    }

    tags = {
      workload = "ai-ml"
      tier     = "premium"
    }
  }

  dev_center_id     = "/subscriptions/.../devcenters/mydevcenter"
  resource_group_id = "/subscriptions/.../resourceGroups/myrg"
  location          = "East US"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| azapi | ~> 2.4.0 |
| azurecaf | ~> 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| azapi | ~> 2.4.0 |
| azurecaf | ~> 1.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings object for naming conventions and tags | `object({...})` | n/a | yes |
| project | Configuration object for the Dev Center Project | `object({...})` | n/a | yes |
| dev_center_id | The ID of the Dev Center | `string` | n/a | yes |
| resource_group_id | The ID of the resource group | `string` | n/a | yes |
| location | The location/region for the project | `string` | n/a | yes |
| tags | Additional tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Dev Center Project |
| name | The name of the Dev Center Project |
| location | The location of the Dev Center Project |
| dev_center_id | The ID of the associated Dev Center |
| dev_center_uri | The URI of the associated Dev Center |
| provisioning_state | The provisioning state of the project |
| identity | The managed identity configuration |
| tags | The tags assigned to the project |

## Configuration Options

### Identity Types

- `"None"`: No managed identity
- `"SystemAssigned"`: System-assigned managed identity
- `"UserAssigned"`: User-assigned managed identity
- `"SystemAssigned, UserAssigned"`: Both system and user-assigned identities

### Azure AI Services Modes

- `"AutoDeploy"`: Automatically deploy Azure AI services
- `"Disabled"`: Disable Azure AI services

### Catalog Item Sync Types

- `"EnvironmentDefinition"`: Sync environment definitions
- `"ImageDefinition"`: Sync image definitions

### Delete Modes

- `"Auto"`: Automatically delete inactive Dev Boxes
- `"Manual"`: Manual deletion only

### Duration Format

For grace period and inactive threshold, use ISO8601 duration format:
- `"PT24H"`: 24 hours
- `"PT72H"`: 72 hours
- `"PT30M"`: 30 minutes

## Validation

The module includes comprehensive input validation:

- Project name must match Azure naming requirements (3-63 characters, alphanumeric with hyphens/underscores)
- Maximum dev boxes per user must be 0 or greater
- All enum values are validated against allowed API values
- Duration formats are validated
- Concurrent session limits are enforced

## Migration from AzureRM

When migrating from the `azurerm` provider:

1. Update provider requirement from `azurerm` to `azapi`
2. Change `resource_group_name` to `resource_group_id`
3. Update module calls to pass resource group ID instead of name
4. Review new configuration options and enable desired features
5. Test thoroughly in a development environment

## Examples

See the `examples/dev_center_project/` directory for complete working examples.

## API Reference

This module uses the Azure DevCenter Projects API version 2025-04-01-preview. For the latest API documentation, see:
https://learn.microsoft.com/en-us/azure/templates/microsoft.devcenter/2025-04-01-preview/projects
