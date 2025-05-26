output "id" {
  description = "The ID of the Dev Center Project"
  value       = azapi_resource.project.id
}

output "name" {
  description = "The name of the Dev Center Project"
  value       = azapi_resource.project.name
}

output "location" {
  description = "The location of the Dev Center Project"
  value       = azapi_resource.project.location
}

output "dev_center_id" {
  description = "The ID of the Dev Center resource this project is associated with"
  value       = var.dev_center_id
}

output "provisioning_state" {
  description = "The provisioning state of the Dev Center Project"
  value       = try(jsondecode(azapi_resource.project.output).properties.provisioningState, null)
}

output "dev_center_uri" {
  description = "The URI of the Dev Center resource this project is associated with"
  value       = try(jsondecode(azapi_resource.project.output).properties.devCenterUri, null)
}

output "identity" {
  description = "The managed identity of the Dev Center Project"
  value       = try(azapi_resource.project.identity, null)
}

output "tags" {
  description = "The tags assigned to the Dev Center Project"
  value       = azapi_resource.project.tags
}
