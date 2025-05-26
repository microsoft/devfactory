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
<!-- END_TF_DOCS -->