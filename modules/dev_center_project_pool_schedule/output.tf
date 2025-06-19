# DevCenter Project Pool Schedule Module Outputs
# Outputs for the DevCenter project pool schedule module

output "id" {
  description = "The resource ID of the DevCenter project pool schedule"
  value       = azapi_resource.dev_center_project_pool_schedule.id
}

output "name" {
  description = "The name of the DevCenter project pool schedule"
  value       = azapi_resource.dev_center_project_pool_schedule.name
}

output "properties" {
  description = "The properties of the DevCenter project pool schedule"
  value       = azapi_resource.dev_center_project_pool_schedule.body.properties
}

output "type" {
  description = "The schedule type (StopDevBox, StartDevBox)"
  value       = azapi_resource.dev_center_project_pool_schedule.body.properties.type
}

output "time" {
  description = "The schedule time in HH:MM format"
  value       = azapi_resource.dev_center_project_pool_schedule.body.properties.time
}

output "time_zone" {
  description = "The schedule time zone"
  value       = azapi_resource.dev_center_project_pool_schedule.body.properties.timeZone
}

output "state" {
  description = "The schedule state (Enabled, Disabled)"
  value       = azapi_resource.dev_center_project_pool_schedule.body.properties.state
}

output "parent_pool_id" {
  description = "The resource ID of the parent DevCenter project pool"
  value       = var.dev_center_project_pool_id
}
