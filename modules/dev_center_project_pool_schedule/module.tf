# DevCenter Project Pool Schedule Module
# This module creates Azure DevCenter project pool schedules using the AzAPI provider
# Following Microsoft.DevCenter/projects/pools/schedules@2025-04-01-preview schema

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4.0"
    }
  }
}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.schedule.tags, {}),
    {
      terraform-azapi-resource-type = "Microsoft.DevCenter/projects/pools/schedules"
      terraform-azapi-version       = "2025-04-01-preview"
    }
  )
}

# DevCenter Project Pool Schedule Resource
resource "azapi_resource" "dev_center_project_pool_schedule" {
  type      = "Microsoft.DevCenter/projects/pools/schedules@2025-04-01-preview"
  name      = "default"
  parent_id = var.dev_center_project_pool_id

  body = {
    properties = {
      # Schedule type (StopDevBox, StartDevBox, etc.)
      type = try(var.schedule.type, "StopDevBox")

      # Frequency (Daily, Weekly, etc.)
      frequency = try(var.schedule.frequency, "Daily")

      # Time in HH:MM format (24-hour)
      time = var.schedule.time

      # Time zone (e.g., "W. Europe Standard Time")
      timeZone = var.schedule.time_zone

      # Schedule state (Enabled, Disabled)
      state = try(var.schedule.state, "Enabled")

      # Tags within properties for schedules
      tags = local.tags
    }
  }

  # Ignore changes to certain computed properties
  lifecycle {
    ignore_changes = [
      body.properties.provisioningState
    ]
  }
}
