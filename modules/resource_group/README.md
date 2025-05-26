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
<!-- END_TF_DOCS -->
