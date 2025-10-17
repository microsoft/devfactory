output "id" {
  description = "The ID of the Dev Center Project Environment Type"
  value       = azapi_resource.dev_center_project_environment_type.id
}

output "name" {
  description = "The name of the Dev Center Project Environment Type"
  value       = azapi_resource.dev_center_project_environment_type.name
}

output "dev_center_project_id" {
  description = "The ID of the parent Dev Center Project"
  value       = var.dev_center_project_id
}

output "deployment_target_id" {
  description = "The deployment target ID for the project environment type (subscription ID)"
  value       = local.subscription_id
}

output "status" {
  description = "The status of the Dev Center Project Environment Type"
  value       = try(azapi_resource.dev_center_project_environment_type.output.properties.status, null)
}

output "provisioning_state" {
  description = "The provisioning state of the Dev Center Project Environment Type"
  value       = try(azapi_resource.dev_center_project_environment_type.output.properties.provisioningState, null)
}

output "user_role_assignments" {
  description = "The user role assignments for the project environment type"
  value       = try(azapi_resource.dev_center_project_environment_type.output.properties.userRoleAssignments, null)
}