# Dev Center Catalog Example - Enhanced Case

This example demonstrates an enterprise-ready DevCenter catalog configuration with multiple catalog types, comprehensive tagging, and production-ready settings.

## Overview

This enhanced configuration creates:

- A production DevCenter with enterprise settings enabled
- Four different catalogs showcasing various use cases:
  1. **Microsoft Official Environments** - Public Microsoft catalog
  2. **Company Custom Environments** - Private company repository
  3. **DevBox Definitions** - Azure DevOps repository with manual sync
  4. **Third-Party Tools** - External partner repository with strict controls

## DevCenter Features Enabled

- **Azure Monitor Agent**: Enabled for dev box monitoring and telemetry
- **Microsoft-Hosted Network**: Enabled for simplified networking
- **Catalog Item Sync**: Enabled for automatic propagation to projects
- **Comprehensive Tagging**: Multi-level tagging strategy for governance

## Catalog Configuration Details

### 1. Microsoft Environments Catalog
- **Purpose**: Official Microsoft environment definitions
- **Repository**: `https://github.com/microsoft/devcenter-catalog.git`
- **Sync**: Scheduled (automatic daily updates)
- **Security**: Public repository, no authentication required
- **Content**: Environment definitions from Microsoft

### 2. Company Custom Environments
- **Purpose**: Internal company-specific environment definitions
- **Repository**: `https://github.com/contoso/devcenter-environments.git`
- **Sync**: Scheduled (automatic daily updates)
- **Security**: Private repository, requires PAT authentication
- **Content**: Custom environments tailored to company needs
- **Compliance**: SOX-compliant environments

### 3. DevBox Definitions
- **Purpose**: Custom dev box configurations and definitions
- **Repository**: Azure DevOps Git repository
- **Sync**: Manual (requires approval for updates)
- **Security**: Private repository, requires PAT authentication
- **Content**: Dev box definitions and configurations
- **Review**: Requires manual review before deployment

### 4. Third-Party Tools
- **Purpose**: Specialized tools from external partners
- **Repository**: Partner-maintained GitHub repository
- **Sync**: Manual (strict change control)
- **Security**: Private repository, requires vendor-provided PAT
- **Content**: Specialized development tools and environments
- **Governance**: High security tier, vendor managed

## Usage

### Prerequisites

1. **Azure Subscription**: Ensure you have appropriate permissions
2. **Key Vault Secrets**: For private repositories, create secrets containing PATs
3. **Repository Access**: Ensure service principals have access to private repositories

### Deployment

1. Set your Azure subscription:
   ```bash
   export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
   ```

2. Run from the repository root:
   ```bash
   terraform init
   terraform plan -var-file=examples/dev_center_catalog/enhanced_case/configuration.tfvars
   terraform apply -var-file=examples/dev_center_catalog/enhanced_case/configuration.tfvars
   ```

3. To destroy:
   ```bash
   terraform destroy -var-file=examples/dev_center_catalog/enhanced_case/configuration.tfvars
   ```

## Security Configuration

### Key Vault Integration

For production deployment, uncomment and configure the `secret_identifier` properties:

```hcl
# Example for GitHub private repository
github = {
  branch            = "main"
  uri               = "https://github.com/contoso/devcenter-environments.git"
  path              = "environments"
  secret_identifier = "https://kv-contoso-prod.vault.azure.net/secrets/github-pat"
}

# Example for Azure DevOps repository
ado_git = {
  branch            = "release"
  uri               = "https://dev.azure.com/contoso/Platform/_git/DevBoxDefinitions"
  path              = "definitions"
  secret_identifier = "https://kv-contoso-prod.vault.azure.net/secrets/ado-pat"
}
```

### Personal Access Token Requirements

1. **GitHub PAT Permissions**:
   - `repo` (Full control of private repositories)
   - `read:org` (Read organization membership)

2. **Azure DevOps PAT Permissions**:
   - `Code (read)` - Read source code and metadata
   - `Project and team (read)` - View projects and teams

### DevCenter Identity Configuration

Ensure the DevCenter's managed identity has:
- **Key Vault Access**: `Key Vault Secrets User` role on the Key Vault
- **Repository Access**: Appropriate permissions on private repositories

## Tagging Strategy

### Infrastructure Tags (Applied to all resources)
- `environment`: Deployment environment (production)
- `project`: Project identifier
- `cost_center`: Cost allocation
- `owner`: Team responsible
- `business_unit`: Business unit

### Resource-Specific Tags (Within catalog properties)
- `catalog_type`: Type of catalog content
- `source`: Origin of the catalog
- `update_schedule`: How often content is updated
- `security_tier`: Security classification
- `compliance`: Compliance requirements

## Sync Strategies

### Scheduled Sync
- **Use Case**: Trusted sources with frequent, safe updates
- **Examples**: Microsoft official catalogs, stable internal repositories
- **Benefits**: Automatic updates, reduced manual overhead
- **Considerations**: Ensure content quality and testing

### Manual Sync
- **Use Case**: Critical systems, third-party content, compliance requirements
- **Examples**: Production templates, external vendor tools
- **Benefits**: Change control, review process, stability
- **Considerations**: Requires manual intervention for updates

## Monitoring and Governance

### Catalog Health Monitoring
- Monitor sync status and failures
- Track catalog usage across projects
- Alert on authentication failures

### Access Control
- Regular review of PAT permissions
- Rotate authentication tokens regularly
- Audit catalog access and usage

### Compliance
- Document catalog sources and approval processes
- Maintain change logs for manual sync catalogs
- Regular security assessments of catalog content

## Best Practices

1. **Separate Catalogs by Purpose**: Environment definitions, dev box definitions, tools
2. **Use Appropriate Sync Types**: Scheduled for trusted sources, manual for critical content
3. **Implement Proper Tagging**: Enable cost tracking and governance
4. **Secure Authentication**: Use Key Vault for PAT storage, rotate regularly
5. **Monitor and Audit**: Track usage, sync status, and access patterns
