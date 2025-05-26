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
| [azapi_resource.environment_type](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.environment_type](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_center_id"></a> [dev\_center\_id](#input\_dev\_center\_id) | The ID of the Dev Center in which to create the environment type | `string` | n/a | yes |
| <a name="input_environment_type"></a> [environment\_type](#input\_environment\_type) | Configuration object for the Dev Center Environment Type | <pre>object({<br/>    name         = string<br/>    display_name = optional(string)<br/>    tags         = optional(map(string))<br/>  })</pre> | n/a | yes |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object | <pre>object({<br/>    prefixes      = list(string)<br/>    random_length = number<br/>    passthrough   = bool<br/>    use_slug      = bool<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional tags to apply to the environment type. Merged with global and resource-specific tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dev_center_id"></a> [dev\_center\_id](#output\_dev\_center\_id) | The ID of the Dev Center |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | The display name of the Dev Center Environment Type |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Dev Center Environment Type |
| <a name="output_name"></a> [name](#output\_name) | The name of the Dev Center Environment Type |
<!-- END_TF_DOCS -->