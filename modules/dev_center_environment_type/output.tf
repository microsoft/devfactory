output "id" {
  description = "The ID of the Dev Center Environment Type"
  value       = azapi_resource.environment_type.id
}

output "name" {
  description = "The name of the Dev Center Environment Type"
  value       = azapi_resource.environment_type.name
}

output "dev_center_id" {
  description = "The ID of the Dev Center"
  value       = var.dev_center_id
}

output "display_name" {
  description = "The display name of the Dev Center Environment Type"
  value       = jsondecode(azapi_resource.environment_type.output).properties.displayName
}
