output "id" {
  description = "The ID of the Dev Center"
  value       = azapi_resource.dev_center.id
}

output "name" {
  description = "The name of the Dev Center"
  value       = azapi_resource.dev_center.name
}

output "identity" {
  description = "The identity of the Dev Center"
  value       = azapi_resource.dev_center.identity
}

output "dev_center_uri" {
  description = "The URI of the Dev Center"
  value       = try(azapi_resource.dev_center.output.properties.devCenterUri, null)
}

output "provisioning_state" {
  description = "The provisioning state of the Dev Center"
  value       = try(azapi_resource.dev_center.output.properties.provisioningState, null)
}

output "location" {
  description = "The location of the Dev Center"
  value       = azapi_resource.dev_center.location
}

output "resource_group_name" {
  description = "The resource group name of the Dev Center"
  value       = var.resource_group_name
}
