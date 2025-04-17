output "id" {
  description = "The ID of the Dev Center"
  value       = azurerm_dev_center.dev_center.id
}

output "name" {
  description = "The name of the Dev Center"
  value       = azurerm_dev_center.dev_center.name
}

output "identity" {
  description = "The identity of the Dev Center"
  value       = azurerm_dev_center.dev_center.identity
}
