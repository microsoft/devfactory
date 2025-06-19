# DevCenter Project Pool Schedule Module

This Terraform module creates Azure DevCenter project pool schedules using the AzAPI provider, following the `Microsoft.DevCenter/projects/pools/schedules@2025-04-01-preview` resource schema.

## Features

- **Flexible Schedule Types**: Supports StopDevBox and StartDevBox schedule types
- **Time Zone Support**: Configure schedules with specific time zones
- **State Management**: Enable or disable schedules as needed
- **Strong Typing**: Comprehensive variable validation for time format, types, and states
- **Tag Management**: Automatic merging of global and resource-specific tags
- **AzAPI Integration**: Uses the latest Azure API preview version for enhanced functionality

## Usage

```hcl
module "dev_center_project_pool_schedule" {
  source = "./modules/dev_center_project_pool_schedule"

  dev_center_project_pool_id = module.dev_center_project_pool.id

  schedule = {
    name      = "daily-shutdown"
    type      = "StopDevBox"
    frequency = "Daily"
    time      = "22:00"
    time_zone = "W. Europe Standard Time"
    state     = "Enabled"
    tags = {
      purpose = "auto-shutdown"
    }
  }

  global_settings = {
    tags = {
      environment = "dev"
      project     = "contoso-devbox"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| azapi | ~> 2.4.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.dev_center_project_pool_schedule](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dev_center_project_pool_id | The resource ID of the DevCenter project pool | `string` | n/a | yes |
| schedule | Configuration for the DevCenter project pool schedule | `object({...})` | n/a | yes |
| global_settings | Global settings for all resources | `object({...})` | `{ tags = {} }` | no |

### Schedule Object Structure

```hcl
schedule = {
  name      = string                         # Schedule name
  type      = optional(string, "StopDevBox") # StopDevBox, StartDevBox
  frequency = optional(string, "Daily")      # Daily, Weekly
  time      = string                         # HH:MM format (24-hour)
  time_zone = string                         # Time zone (e.g., "W. Europe Standard Time")
  state     = optional(string, "Enabled")    # Enabled, Disabled
  tags      = optional(map(string), {})      # Resource-specific tags
}
```

## Outputs

| Name | Description |
|------|-------------|
| id | The resource ID of the DevCenter project pool schedule |
| name | The name of the DevCenter project pool schedule |
| properties | The properties of the DevCenter project pool schedule |
| type | The schedule type (StopDevBox, StartDevBox) |
| time | The schedule time in HH:MM format |
| time_zone | The schedule time zone |
| state | The schedule state (Enabled, Disabled) |
| parent_pool_id | The resource ID of the parent DevCenter project pool |

## Schedule Types

- **StopDevBox**: Automatically stops dev boxes at the specified time
- **StartDevBox**: Automatically starts dev boxes at the specified time

## Time Zones

Common time zones for European deployments:
- `W. Europe Standard Time` (West Europe)
- `Central Europe Standard Time` (Central Europe)
- `GMT Standard Time` (Greenwich Mean Time)

## Validation

The module includes comprehensive validation for:
- Time format (HH:MM in 24-hour format)
- Schedule types (StopDevBox, StartDevBox)
- Frequency values (Daily, Weekly)
- State values (Enabled, Disabled)
- DevCenter project pool resource ID format

## Examples

### Daily Auto-Shutdown Schedule

```hcl
schedule = {
  name      = "daily-shutdown"
  type      = "StopDevBox"
  frequency = "Daily"
  time      = "22:00"
  time_zone = "W. Europe Standard Time"
  state     = "Enabled"
}
```

### Morning Auto-Start Schedule

```hcl
schedule = {
  name      = "morning-start"
  type      = "StartDevBox"
  frequency = "Daily"
  time      = "08:00"
  time_zone = "W. Europe Standard Time"
  state     = "Enabled"
}
```
