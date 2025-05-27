# Azure DevCenter Catalog Module

This module creates an Azure DevCenter Catalog using the AzAPI provider.

## Features

- Supports both GitHub and Azure DevOps Git repositories
- Configurable sync type (Manual or Scheduled)
- Comprehensive validation for inputs
- Support for resource tags and repository-specific tags
- Compatible with Azure DevCenter 2025-04-01-preview API

## Usage

### GitHub Catalog Example

```hcl
module "dev_center_catalog" {
  source = "./modules/dev_center_catalog"

  global_settings = {
    prefixes      = ["contoso"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  dev_center_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-example/providers/Microsoft.DevCenter/devcenters/dc-example"

  catalog = {
    name      = "github-catalog"
    sync_type = "Scheduled"

    github = {
      branch            = "main"
      uri               = "https://github.com/contoso/dev-box-definitions.git"
      path              = "definitions"
      secret_identifier = "https://kv-example.vault.azure.net/secrets/github-pat"
    }

    tags = {
      purpose = "development"
      team    = "platform"
    }
  }
}
```

### Azure DevOps Git Catalog Example

```hcl
module "dev_center_catalog" {
  source = "./modules/dev_center_catalog"

  global_settings = {
    prefixes      = ["contoso"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  dev_center_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-example/providers/Microsoft.DevCenter/devcenters/dc-example"

  catalog = {
    name      = "ado-catalog"
    sync_type = "Manual"

    ado_git = {
      branch            = "develop"
      uri               = "https://dev.azure.com/contoso/MyProject/_git/DevBoxDefinitions"
      path              = "catalog-items"
      secret_identifier = "https://kv-example.vault.azure.net/secrets/ado-pat"
    }

    resource_tags = {
      catalog_type = "ado"
      version      = "v1"
    }
  }
}
```

## Azure API Reference

This module implements the [Microsoft.DevCenter/devcenters/catalogs](https://learn.microsoft.com/en-us/azure/templates/microsoft.devcenter/2025-04-01-preview/devcenters/catalogs) resource type using API version 2025-04-01-preview.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.4.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~> 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.4.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.28 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.catalog](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.catalog](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catalog"></a> [catalog](#input\_catalog) | Configuration object for the Dev Center Catalog | <pre>object({<br/>    name = string<br/>    tags = optional(map(string))<br/><br/>    # GitHub catalog configuration<br/>    github = optional(object({<br/>      branch            = string<br/>      uri               = string<br/>      path              = optional(string)<br/>      secret_identifier = optional(string)<br/>    }))<br/><br/>    # Azure DevOps Git catalog configuration<br/>    ado_git = optional(object({<br/>      branch            = string<br/>      uri               = string<br/>      path              = optional(string)<br/>      secret_identifier = optional(string)<br/>    }))<br/><br/>    # Sync type: Manual or Scheduled<br/>    sync_type = optional(string)<br/><br/>    # Resource-specific tags (separate from infrastructure tags)<br/>    resource_tags = optional(map(string))<br/>  })</pre> | n/a | yes |
| <a name="input_dev_center_id"></a> [dev\_center\_id](#input\_dev\_center\_id) | The resource ID of the parent Dev Center | `string` | n/a | yes |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object | <pre>object({<br/>    prefixes      = optional(list(string))<br/>    random_length = optional(number)<br/>    passthrough   = optional(bool)<br/>    use_slug      = optional(bool)<br/>    tags          = optional(map(string))<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_uri"></a> [catalog\_uri](#output\_catalog\_uri) | The URI of the catalog repository |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Dev Center Catalog |
| <a name="output_name"></a> [name](#output\_name) | The name of the Dev Center Catalog |
| <a name="output_properties"></a> [properties](#output\_properties) | The properties of the Dev Center Catalog |
| <a name="output_sync_type"></a> [sync\_type](#output\_sync\_type) | The sync type of the catalog |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the Dev Center Catalog |
<!-- END_TF_DOCS -->

## Validation Rules

- Catalog name must be 3-63 characters, alphanumeric with hyphens, underscores, and periods
- Sync type must be either "Manual" or "Scheduled"
- Exactly one of GitHub or Azure DevOps Git configuration must be specified
- Dev Center ID must be a valid resource ID format

## Security Considerations

- Use Key Vault to store Git repository access tokens
- Ensure the Dev Center identity has appropriate access to the Key Vault
- Use least privilege access for repository authentication
- Consider using managed identity where possible
