output "id" {
  description = "The ID of the Dev Center Project"
  value       = azurerm_dev_center_project.project.id
}

output "dev_center_uri" {
  description = "The URI of the Dev Center resource this project is associated with."
  value       = azurerm_dev_center_project.project.dev_center_uri
}
