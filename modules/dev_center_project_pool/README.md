# DevCenter Project Pool Module

This module creates Azure DevCenter project pools using the AzAPI provider, following the official Microsoft documentation for API version `2025-04-01-preview`.

## Features

- **DevCenter Project Pools**: Creates project pools with DevBox definitions
- **Network Configuration**: Supports both Microsoft-hosted and custom network connections
- **Security Settings**: Configurable local administrator access and single sign-on
- **Stop on Disconnect**: Automatic shutdown when users disconnect for specified period
- **Flexible Licensing**: Support for Windows Client and Server licensing
- **Tag Management**: Comprehensive tagging with global and resource-specific tags
- **Modular Design**: Separate schedule management through dedicated schedule module

## Usage

```hcl
module "dev_center_project_pool" {
  source = "./modules/dev_center_project_pool"

  global_settings = var.global_settings
  pool = {
    name                     = "my-dev-pool"
    display_name            = "My Development Pool"
    dev_box_definition_name = "windows-vs-definition"
    local_administrator_enabled = true
    stop_on_disconnect_grace_period_minutes = 60

    tags = {
      environment = "dev"
      purpose     = "development"
    }
  }

  dev_center_project_id = "/subscriptions/.../projects/my-project"
  location             = "westeurope"
  resource_group_id    = "/subscriptions/.../resourceGroups/my-rg"
}

# Separate schedule management
module "daily_shutdown_schedule" {
  source = "./modules/dev_center_project_pool_schedule"

  dev_center_project_pool_id = module.dev_center_project_pool.id

  schedule = {
    name      = "daily-shutdown"
    time      = "22:00"
    time_zone = "W. Europe Standard Time"
    type      = "StopDevBox"
    state     = "Enabled"
  }

  global_settings = var.global_settings
}
```
```

## Requirements

| Name | Version |
|------|---------|
| azapi | ~> 2.4.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.dev_center_project_pool](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_resource) | resource |
| [azapi_resource.dev_center_project_pool_schedule](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dev_center_project_id | The ID of the DevCenter project | `string` | n/a | yes |
| global_settings | Global settings for the module | `object({...})` | `{}` | no |
| location | The Azure region where the pool will be deployed | `string` | n/a | yes |
| pool | DevCenter project pool configuration | `object({...})` | n/a | yes |
| resource_group_id | The ID of the resource group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dev_box_definition_name | The DevBox definition name used by this pool |
| id | The ID of the DevCenter project pool |
| local_administrator_enabled | Whether local administrator is enabled |
| name | The name of the DevCenter project pool |
| network_connection_name | The network connection name used by this pool |
| properties | The properties of the DevCenter project pool |
| resource_id | The full resource ID of the DevCenter project pool |
| schedule_ids | Map of schedule names to their resource IDs |
| tags | The tags applied to the DevCenter project pool |

## Configuration Options

### Pool Configuration

- **name**: (Required) Name of the project pool
- **display_name**: (Optional) Display name shown in Azure portal
- **dev_box_definition_name**: (Required) Reference to the DevBox definition
- **local_administrator_enabled**: (Optional) Enable local admin rights (default: false)
- **network_connection_name**: (Optional) Network connection (default: "default" for Microsoft-hosted)
- **stop_on_disconnect_grace_period_minutes**: (Optional) Auto-shutdown delay (60-480 minutes, default: 60)
- **license_type**: (Optional) Windows licensing type (default: "Windows_Client")
- **virtual_network_type**: (Optional) Network type (default: "Managed")
- **single_sign_on_status**: (Optional) SSO configuration (default: "Disabled")

### Schedule Configuration

- **name**: (Required) Schedule name
- **type**: (Optional) Schedule type (default: "StopDevBox")
- **frequency**: (Optional) Schedule frequency (default: "Daily")
- **time**: (Required) Time in HH:MM format
- **time_zone**: (Required) IANA timezone (e.g., "Europe/Brussels")
- **state**: (Optional) Schedule state (default: "Enabled")

## Best Practices

1. **Cost Optimization**: Use separate schedule modules to automatically stop DevBoxes during non-working hours
2. **Security**: Enable local administrator only when necessary
3. **Network**: Use Microsoft-hosted network for simplicity unless custom networking is required
4. **Grace Period**: Set appropriate disconnect grace period (minimum 60 minutes)
5. **Tagging**: Apply consistent tags for cost tracking and resource management
6. **Modularity**: Use the separate schedule module for better reusability and management

## Notes

- This module uses the preview API version `2025-04-01-preview`
- Pool schedules are managed separately through the `dev_center_project_pool_schedule` module
- The module automatically handles tag merging between global and resource-specific tags
- Lifecycle rules ignore computed properties like `healthStatus` and `provisioningState`
