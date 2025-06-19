# DevCenter Project Pool Module Outputs

output "id" {
  description = "The ID of the DevCenter project pool"
  value       = azapi_resource.dev_center_project_pool.id
}

output "name" {
  description = "The name of the DevCenter project pool"
  value       = azapi_resource.dev_center_project_pool.name
}

output "resource_id" {
  description = "The full resource ID of the DevCenter project pool"
  value       = azapi_resource.dev_center_project_pool.id
}

output "properties" {
  description = "The properties of the DevCenter project pool"
  value       = azapi_resource.dev_center_project_pool.output
  sensitive   = false
}

output "dev_box_definition_name" {
  description = "The DevBox definition name used by this pool"
  value       = var.pool.dev_box_definition_name
}

output "local_administrator_enabled" {
  description = "Whether local administrator is enabled for DevBoxes in this pool"
  value       = try(var.pool.local_administrator_enabled, false)
}

output "network_connection_name" {
  description = "The network connection name used by this pool"
  value       = try(var.pool.network_connection_name, "default")
}

output "tags" {
  description = "The tags applied to the DevCenter project pool"
  value       = azapi_resource.dev_center_project_pool.tags
}
