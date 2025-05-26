# Dev Center Module

This module creates an Azure Dev Center using the AzAPI provider to ensure access to the latest features and API versions.

## Features

- **AzAPI Provider**: Uses AzAPI v2.4.0 for direct Azure REST API access
- **Identity Support**: Supports SystemAssigned, UserAssigned, and dual identity configurations
- **Latest API Version**: Uses Microsoft.DevCenter/devcenters@2025-04-01-preview
- **Enhanced Properties**: Supports DevBox provisioning settings, encryption, network settings, and project catalog settings
- **Naming Conventions**: Integrated with azurecaf for consistent naming
- **Tag Management**: Merges global and resource-specific tags
- **Input Validation**: Comprehensive validation for all configuration options

## Usage

### Simple Dev Center

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

### Dev Center with System-Assigned Identity

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
    tags = {
      environment = "production"
    }
  }

  resource_group_name = "my-resource-group"
  location           = "East US"
}
```

### Dev Center with User-Assigned Identity

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
    identity = {
      type = "UserAssigned"
      identity_ids = [
        "/subscriptions/your-subscription/resourceGroups/identity-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
      ]
    }
  }

  resource_group_name = "my-resource-group"
  location           = "East US"
}
```

### Enhanced Dev Center with 2025-04-01-preview Features

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
    name         = "my-enhanced-devcenter"
    display_name = "Production DevCenter with Enhanced Features"

    identity = {
      type = "SystemAssigned"
    }

    # DevBox provisioning settings
    dev_box_provisioning_settings = {
      install_azure_monitor_agent_enable_installation = true
    }

    # Network settings
    network_settings = {
      microsoft_hosted_network_enable_status = "Enabled"
    }

    # Project catalog settings
    project_catalog_settings = {
      catalog_item_sync_enable_status = "Enabled"
    }

    # Customer-managed encryption (optional)
    encryption = {
      customer_managed_key_encryption = {
        key_encryption_key_identity = {
          identity_type = "UserAssigned"
          user_assigned_identity_resource_id = "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity"
        }
        key_encryption_key_url = "https://vault.vault.azure.net/keys/key/version"
      }
    }

    tags = {
      environment = "production"
      api_version = "2025-04-01-preview"
    }
  }

  resource_group_name = "my-resource-group"
  location           = "East US"
}
```
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
    identity = {
      type = "SystemAssigned, UserAssigned"
      identity_ids = [
        "/subscriptions/your-subscription/resourceGroups/identity-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity1",
        "/subscriptions/your-subscription/resourceGroups/identity-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity2"
      ]
    }
  }

  resource_group_name = "my-resource-group"
  location           = "East US"
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings object for naming conventions | `object({})` | n/a | yes |
| dev_center | Configuration object for the Dev Center | `object({})` | n/a | yes |
| resource_group_name | The name of the resource group | `string` | n/a | yes |
| location | The Azure region where the Dev Center will be created | `string` | n/a | yes |

### dev_center Object Structure

```hcl
dev_center = {
  name         = string                    # Name of the Dev Center
  display_name = optional(string)          # Display name of the Dev Center
  tags         = optional(map(string))     # Resource-specific tags

  identity = optional(object({             # Identity configuration
    type         = string                  # "SystemAssigned", "UserAssigned", or "SystemAssigned,UserAssigned"
    identity_ids = optional(list(string))  # List of user-assigned identity resource IDs
  }))

  # DevBox provisioning settings (2025-04-01-preview)
  dev_box_provisioning_settings = optional(object({
    install_azure_monitor_agent_enable_installation = optional(bool)
  }))

  # Encryption settings (2025-04-01-preview)
  encryption = optional(object({
    customer_managed_key_encryption = optional(object({
      key_encryption_key_identity = optional(object({
        identity_type                      = optional(string)  # "UserAssigned"
        delegated_identity_client_id       = optional(string)
        user_assigned_identity_resource_id = optional(string)
      }))
      key_encryption_key_url = optional(string)
    }))
  }))

  # Network settings (2025-04-01-preview)
  network_settings = optional(object({
    microsoft_hosted_network_enable_status = optional(string)  # "Enabled" or "Disabled"
  }))

  # Project catalog settings (2025-04-01-preview)
  project_catalog_settings = optional(object({
    catalog_item_sync_enable_status = optional(string)  # "Enabled" or "Disabled"
  }))
}
```

### global_settings Object Structure

```hcl
global_settings = {
  prefixes      = optional(list(string))  # Naming prefixes
  random_length = optional(number)        # Length of random suffix
  passthrough   = optional(bool)          # Whether to pass through name as-is
  use_slug      = optional(bool)          # Whether to use resource-specific slug
}
```

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Dev Center |
| name | The name of the Dev Center |
| identity | The identity configuration of the Dev Center |
| dev_center_uri | The URI of the Dev Center |
| provisioning_state | The provisioning state of the Dev Center |
| location | The location of the Dev Center |
| resource_group_name | The resource group name of the Dev Center |

## Examples

See the `/examples/dev_center/` directory for complete working examples:

- `simple_case/` - Basic Dev Center with minimal configuration
- `enhanced_case/` - Dev Center with 2025-04-01-preview features
- `system_assigned_identity/` - Dev Center with system-assigned managed identity
- `user_assigned_identity/` - Dev Center with user-assigned managed identity
- `dual_identity/` - Dev Center with both system and user-assigned identities

## Migration from AzureRM

This module replaces the previous azurerm_dev_center implementation with azapi_resource for better API coverage and future-proofing. The interface remains backward compatible:

- All existing variable structures are preserved
- Output values maintain the same structure
- Default behavior includes SystemAssigned identity for compatibility

### Key Changes

1. **Provider**: Changed from AzureRM to AzAPI
2. **API Version**: Updated to preview 2025-04-01-preview version
3. **Identity Default**: SystemAssigned identity is now the default behavior
4. **Enhanced Features**: Added support for DevBox provisioning settings, encryption, network settings, and project catalog settings
5. **Input Validation**: Comprehensive validation for all configuration parameters
6. **Resource Properties**: Exposed through response_export_values for extensibility

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
| azurerm | ~> 4.26.0 |

## Resources

| Name | Type |
|------|------|
| azapi_resource.dev_center | resource |
| azurecaf_name.dev_center | resource |
| azurerm_client_config.current | data source |
