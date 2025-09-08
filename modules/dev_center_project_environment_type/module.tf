terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.29"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4.0"
    }
  }
}

data "azapi_client_config" "current" {}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.project_environment_type.tags, {})
  )

  # Extract subscription ID for deploymentTargetId
  # The deploymentTargetId should be the subscription ID, not the full environment type resource ID
  subscription_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
}

resource "azapi_resource" "dev_center_project_environment_type" {
  type      = "Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview"
  name      = var.environment_type_name
  parent_id = var.dev_center_project_id

  body = {
    properties = merge(
      {
        # The deploymentTargetId should be the subscription ID, not the environment type resource ID
        # This specifies the subscription where environment resources will be deployed
        deploymentTargetId = local.subscription_id
      },
      try(var.project_environment_type.status, null) != null ? {
        status = var.project_environment_type.status
      } : {},
      try(var.project_environment_type.user_role_assignments, null) != null ? {
        userRoleAssignments = var.project_environment_type.user_role_assignments
      } : {}
    )
    tags = local.tags
  }

  response_export_values = ["properties"]

  # Ignore changes to system-managed tags that Azure automatically adds
  lifecycle {
    ignore_changes = [
      tags["hidden-title"]
    ]
  }
}