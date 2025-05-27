output "id" {
  description = "The ID of the Dev Center Catalog"
  value       = azapi_resource.catalog.id
}

output "name" {
  description = "The name of the Dev Center Catalog"
  value       = azapi_resource.catalog.name
}

output "properties" {
  description = "The properties of the Dev Center Catalog"
  value       = azapi_resource.catalog.output
}

output "catalog_uri" {
  description = "The URI of the catalog repository"
  value = try(
    azapi_resource.catalog.output.properties.gitHub.uri,
    azapi_resource.catalog.output.properties.adoGit.uri,
    null
  )
}

output "sync_type" {
  description = "The sync type of the catalog"
  value       = try(azapi_resource.catalog.output.properties.syncType, null)
}

output "tags" {
  description = "The tags assigned to the Dev Center Catalog"
  value       = azapi_resource.catalog.tags
}
