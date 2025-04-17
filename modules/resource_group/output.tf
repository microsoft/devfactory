output "id" {
  description = "The ID of the Resource Group"
  value       = azurerm_resource_group.resource_group.id
}

output "name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.resource_group.name
}

output "location" {
  description = "The location of the Resource Group"
  value       = azurerm_resource_group.resource_group.location
}
