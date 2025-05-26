# Azure DevCenter Environment Type Module

This module manages Azure DevCenter Environment Types using the AzAPI provider with direct Azure REST API access for the latest features.

## Overview

The Environment Type module enables the creation and management of environment types within Azure DevCenter. It uses the AzAPI provider to ensure compatibility with the latest Azure features and APIs, following DevFactory standardization patterns.

## Features

- Uses AzAPI provider v2.4.0 for latest Azure features
- Implements latest Azure DevCenter API (2025-04-01-preview)
- Supports flexible environment type configurations
- Integrates with azurecaf naming conventions
- Manages resource tags (global + specific)
- Provides strong input validation

## Simple Usage

```hcl
module "dev_center_environment_type" {
  source = "./modules/dev_center_environment_type"

  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  dev_center_id = "/subscriptions/.../devcenters/mydevcenter"

  environment_type = {
    name         = "dev-env"
    display_name = "Development Environment"
  }
}
```

## Advanced Usage

```hcl
module "dev_center_environment_types" {
  source = "./modules/dev_center_environment_type"

  for_each = try(var.dev_center_environment_types, {})

  global_settings  = var.global_settings
  dev_center_id    = module.dev_centers[each.value.dev_center.key].id
  environment_type = each.value
  tags             = try(each.value.tags, {})
}

# Configuration example
dev_center_environment_types = {
  envtype1 = {
    name         = "terraform-env"
    display_name = "Terraform Environment Type"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_environment_type"
    }
  }
}
```

For more examples, see the [environment type examples](../../../examples/dev_center_environment_type/).

## Resources

- Azure DevCenter Environment Type (`Microsoft.DevCenter/devcenters/environmentTypes`)

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| global_settings | Global settings object for naming conventions | object | Yes |
| dev_center_id | The ID of the Dev Center in which to create the environment type | string | Yes |
| environment_type | Configuration object for the Dev Center Environment Type | object | Yes |
| tags | Optional tags to apply to the environment type | map(string) | No |

### environment_type Object

| Name | Description | Type | Required |
|------|-------------|------|----------|
| name | The name of the environment type | string | Yes |
| display_name | The display name of the environment type (defaults to name if not provided) | string | No |
| tags | Optional tags to apply to the environment type | map(string) | No |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Dev Center Environment Type |
| name | The name of the Dev Center Environment Type |
| dev_center_id | The ID of the Dev Center |
| display_name | The display name of the Dev Center Environment Type |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->