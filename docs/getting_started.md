# Getting Started with DevFactory

This guide helps you get started with deploying a development environment using DevFactory.

## Prerequisites

- [Terraform](https://www.terraform.io/) (version 1.9.0 or later)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (latest version)
- Azure subscription with appropriate permissions
- Git client

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/devfactory.git
cd devfactory
```

### 2. Authenticate with Azure

First, log in to Azure:

```bash
az login
```

Then set your subscription ID. You can either:

a. Export it directly if you know your subscription ID:
```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```

b. Or get it from your Azure CLI current account and export it in one command:
```bash
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
```

You can verify the exported subscription ID with:
```bash
echo $ARM_SUBSCRIPTION_ID
```

Note: We use environment variables for the subscription ID instead of including it in configuration files. If you have multiple subscriptions, you can list them with `az account list --query "[].{name:name, subscriptionId:id}" -o table` and then select the right one using `az account set --subscription "subscription-id"` before exporting the ARM_SUBSCRIPTION_ID.

### 3. Choose an Example Configuration

The examples directory contains ready-to-use configurations for different scenarios. For instance, to start with a simple resource group configuration:

```bash
# You don't need to copy the file - reference it directly from the examples directory
terraform init
terraform plan -var-file=examples/resource_group/simple_case/configuration.tfvars
```

Each example includes:
- Global settings for consistent naming
- Resource-specific configurations
- Parent-child resource relationships where needed

### 4. Apply the Configuration

After reviewing the plan, apply it:

```bash
terraform apply -var-file=examples/resource_group/simple_case/configuration.tfvars
```

### 5. Clean Up Resources

When you're done, you can remove all created resources:

```bash
terraform destroy -var-file=examples/resource_group/simple_case/configuration.tfvars
```

## Example Scenarios

### Basic Resource Group Creation

The simplest example creates resource groups with standardized naming:

```hcl
# examples/resource_group/simple_case/configuration.tfvars
global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
}

resource_groups = {
  rg1 = {
    name   = "devfactory-core-unique"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "core-infrastructure"
    }
  }
}
```

### Dev Center with DevBox Setup

A more complex example that sets up a Dev Center with DevBox configuration:

```hcl
# examples/dev_center/simple_case/configuration.tfvars
global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
}

resource_groups = {
  rg1 = {
    name   = "devfactory-dc"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name = "devcenter"
    resource_group = {
      key = "rg1"  # References the resource group above
    }
    identity = {
      type = "SystemAssigned"
    }
  }
}

dev_center_dev_box_definitions = {
  definition1 = {
    name = "windows11-dev"
    dev_center = {
      key = "devcenter1"  # References the dev center above
    }
    image_reference = {
      offer     = "windows-11"
      publisher = "microsoftwindowsdesktop"
      sku       = "win11-22h2-ent"
      version   = "latest"
    }
    sku_name = "general_i_8c32gb256ssd_v2"
  }
}
```

## Best Practices

1. **Resource Naming**
   - Let the Azure CAF naming module handle resource names
   - Use the global_settings block to ensure consistent naming patterns
   - Include meaningful prefixes and suffixes

2. **Resource Organization**
   - Group related resources in the same resource group
   - Use tags consistently for environment, workload, and resource type
   - Reference parent resources using the key property instead of hard-coded IDs

3. **Configuration Management**
   - Never include subscription IDs in configuration files
   - Use environment variables for sensitive information
   - Keep configurations in version control (excluding sensitive data)

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Ensure ARM_SUBSCRIPTION_ID is set correctly
   - Verify Azure CLI authentication with `az account show`
   - Check required permissions in Azure

2. **Resource Creation Failures**
   - Validate region availability for services
   - Check resource name uniqueness
   - Verify resource dependencies are correctly referenced

3. **Configuration Issues**
   - Ensure all required variables are provided
   - Check for correct resource group references
   - Verify resource SKUs are available in your subscription

### Getting Help

If you encounter issues:
1. Check the Azure provider documentation
2. Review the module documentation in this repository
3. File an issue with details about your configuration

## Next Steps

- Explore additional examples in the `/examples` directory
- Review the module documentation for advanced configurations
- Set up CI/CD pipelines for automated deployments
