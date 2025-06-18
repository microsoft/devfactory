# Getting Started with DevFactory

This guide helps you get started with deploying a development environment using DevFactory.

## Prerequisites

- [Terraform](https://www.terraform.io/) (version 1.9.0 or later)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (latest version)
- Azure subscription with appropriate permissions
- Git client

## Development Environment Setup

### Using GitHub Codespaces

This repository includes a configured dev container that works seamlessly with GitHub Codespaces. To get started:

1. Navigate to the repository on GitHub
2. Click the green "Code" button
3. Select "Codespaces" tab
4. Click "Create codespace on main"

The dev container includes all necessary tools pre-installed:
- Terraform CLI with TFLint and Terragrunt
- Azure CLI with Azure development extensions
- Docker CLI for container management
- GitHub CLI (`gh`) for GitHub operations
- Node.js, npm, and ESLint for JavaScript development

### Model Context Protocol (MCP) Support

This project includes MCP (Model Context Protocol) server integrations for enhanced AI-assisted development:

- **Terraform MCP Server**: Provides seamless integration with Terraform Registry APIs for Infrastructure as Code development
- **Azure MCP Server**: Enables AI agents to interact with Azure services like Dev Center, Dev Box, Storage, Cosmos DB, and more

#### Important: Using MCP in Codespaces

> **Note:** If you want to use MCP features in GitHub Codespaces, you need to switch to the VS Code Insider version. The stable version of VS Code does not currently support MCP in Codespaces environments.

To enable MCP in Codespaces:

1. When creating a new Codespace, click on the gear icon next to "Create codespace"
2. Select "Configure and create codespace"
3. Under "Editor preference", choose "VS Code Insider (Web)"
4. Create the codespace

Alternatively, if you already have a Codespace running:

1. Open your existing Codespace
2. Go to Settings (gear icon in bottom left)
3. Select "Switch to Insider" if available
4. Restart the Codespace

The MCP servers provide advanced capabilities for:
- Automated Terraform resource discovery and documentation
- Azure resource management and querying
- Infrastructure planning and deployment assistance
- Real-time Azure service integration

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

Then set up your subscription ID. Here are the steps:

1. List all available subscriptions:
```bash
az account list --query "[].{name:name, subscriptionId:id, state:state, isDefault:isDefault}" -o table
```

2. If you have multiple subscriptions, select the one you want to use:
```bash
az account set --subscription "subscription-name-or-id"
```

3. Export the subscription ID as an environment variable. You can either:

a. Export it directly if you know your subscription ID:
```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```

b. Or get it from your current Azure CLI account and export it in one command:
```bash
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
```

4. Verify the exported subscription:
```bash
# Check the environment variable
echo $ARM_SUBSCRIPTION_ID

# Verify it matches your current Azure CLI subscription
az account show --query "[name,id]" -o tsv
```

Note: We use environment variables for the subscription ID instead of including it in configuration files. This approach is more secure and follows infrastructure-as-code best practices. The VS Code tasks in this project will automatically handle exporting the subscription ID for you.

### 3. Choose How to Run Terraform Commands

You have two options for running Terraform commands:

#### Option 1: Using VS Code Tasks (Recommended)

The project includes predefined VS Code tasks for easy execution:

1. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
2. Type "Tasks: Run Task"
3. Select one of the following tasks:
   - `Terraform: Plan Dev Center Example` - Preview changes
   - `Terraform: Apply Dev Center Example` - Apply changes
   - `Terraform: Destroy Dev Center Example` - Remove resources

When you run any task, you'll be prompted to select which example configuration to use:
- Simple case
- System assigned identity
- User assigned identity
- Dual identity

The tasks automatically:
- Get your Azure subscription ID from Azure CLI
- Set it as an environment variable
- Run the selected Terraform command with your chosen configuration

#### Option 2: Using Command Line

If you prefer using the command line directly:

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

When you're done, you can remove all created resources using either VS Code tasks or the command line:

Using VS Code tasks:
1. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
2. Type "Tasks: Run Task"
3. Select "Terraform: Destroy Dev Center Example"
4. Choose the configuration to destroy

Using command line:
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
    name = "win11-dev"
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
