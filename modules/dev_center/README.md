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
<!-- END_TF_DOCS -->