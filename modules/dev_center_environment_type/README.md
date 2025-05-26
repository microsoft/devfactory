# Azure DevCenter Environment Type Module

This module manages Azure DevCenter Environment Types using the AzAPI provider.

## Usage

```hcl
module "dev_center_environment_types" {
  source = "./modules/dev_center_environment_type"

  for_each = try(var.dev_center_environment_types, {})

  global_settings  = var.global_settings
  dev_center_id    = module.dev_centers[each.value.dev_center.key].id
  environment_type = each.value
  tags             = try(each.value.tags, {})
}
```

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

## Example

```hcl
dev_center_environment_types = {
  envtype1 = {
    name         = "terraform-env"
    display_name = "Terraform Environment Type" # Optional, defaults to name if not provided
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
