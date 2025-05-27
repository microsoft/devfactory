# Azure DevCenter Catalog Example - Simple Case

This example demonstrates how to create DevCenter catalogs using both GitHub and Azure DevOps Git repositories.

## Overview

This configuration creates:
- A resource group
- A DevCenter
- Two catalogs:
  - GitHub-based catalog with scheduled sync
  - Azure DevOps Git-based catalog with manual sync

## Usage

1. Set your Azure subscription:
   ```bash
   export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
   ```

2. Run from the repository root:
   ```bash
   terraform init
   terraform plan -var-file=examples/dev_center_catalog/simple_case/configuration.tfvars
   terraform apply -var-file=examples/dev_center_catalog/simple_case/configuration.tfvars
   ```

3. To destroy:
   ```bash
   terraform destroy -var-file=examples/dev_center_catalog/simple_case/configuration.tfvars
   ```

## Configuration Details

### GitHub Catalog
- **Repository**: `https://github.com/microsoft/devcenter-catalog.git`
- **Branch**: `main`
- **Path**: `Environment-Definitions`
- **Sync Type**: `Scheduled`

### Azure DevOps Git Catalog
- **Repository**: `https://dev.azure.com/contoso/Platform/_git/DevBoxDefinitions`
- **Branch**: `develop`
- **Path**: `definitions`
- **Sync Type**: `Manual`

## Authentication

For private repositories, you'll need to:
1. Create a Personal Access Token (PAT) for the repository
2. Store it in Azure Key Vault
3. Add the `secret_identifier` property pointing to the Key Vault secret
4. Ensure the DevCenter has access to the Key Vault

Example with authentication:
```hcl
github = {
  branch            = "main"
  uri               = "https://github.com/private-org/private-repo.git"
  path              = "catalog-items"
  secret_identifier = "https://kv-example.vault.azure.net/secrets/github-pat"
}
```

## Notes

- The DevCenter must exist before creating catalogs
- Each catalog must specify either GitHub or Azure DevOps Git configuration, but not both
- Sync type determines how often the catalog synchronizes with the repository
- Resource tags are separate from infrastructure tags and are stored within the catalog properties
