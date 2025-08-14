# DevFactory

Welcome to the DevFactory project!

## Introduction

DevFactory is a Terraform-based project designed to streamline the setup and configuration of modern development environments on Azure. It uses a modular approach with consistent patterns to deploy and manage Azure resources, with a focus on Azure Dev Center and DevBox capabilities.

The initial north star for this project is to build a development factory represented in the following architecture diagram:

![DevFactory](docs/images/devfactoryv1.png)

## Key Features

- **Modular Design**: Each Azure resource type has its own module with consistent structure
- **Flexible Configuration**: Use variable files to create different resource combinations
- **Naming Standards**: Integrated Azure CAF naming conventions
- **Resource Association**: Seamless connection between related resources
- **Complete Examples**: Ready-to-use examples for various deployment scenarios

## Components

DevFactory currently automates the setup of the following components:

### Azure Dev Center Components

- Resource Groups
- Dev Centers
- DevBox Definitions
- Projects
- Environment Types
- Network Connections
- Galleries
- Catalogs

### Roadmap Components

- GitHub Enterprise Automation (organizations parameters, actions settings, etc.)
- GitHub Hosted Compute Networking
- Azure Kubernetes Services for GitHub Runners with Actions Runner Controller
- Azure Container Registry
- Azure DevBox

### AI foundations (roadmap)

- Azure Application Gateway
- Azure Container Apps
- Azure Container Registry
- Azure Kubernetes Services
- Azure Cognitive Services

## Quick Start

To get started with the DevFactory project:

1. Clone this repository to your local machine, or Click on "Open in Codespace"
2. Login to your Azure Subscription using `az login`
3. Select an example configuration from the `examples` directory
4. Customize the variables in the selected `.tfvars` file
5. Initialize Terraform: `terraform init`
6. Plan your deployment: `terraform plan -var-file=configuration.tfvars`
7. Apply the configuration: `terraform apply -var-file=configuration.tfvars`

For detailed instructions, see our [Getting Started Guide](docs/getting_started.md).

### Development Environment

This project includes:
- **GitHub Codespaces Support**: Pre-configured dev container with all necessary tools
- **MCP Integration**: Model Context Protocol servers for Terraform and Azure for AI-assisted development

> **Note for Codespaces Users**: To use MCP features in GitHub Codespaces, switch to VS Code Insider version. See the [Getting Started Guide](docs/getting_started.md) for detailed instructions.

## Documentation

The project includes comprehensive documentation to help you understand and use DevFactory effectively:

- [Getting Started Guide](docs/getting_started.md) - Instructions for setting up and deploying your first resources
- [Coding Conventions](docs/conventions.md) - Standards and best practices for the codebase
- [Module Guide](docs/module_guide.md) - Detailed information about each module's functionality and usage
- [GitHub Coding Agent Guide](docs/coding_agent.md) - Instructions for using the GitHub Coding Agent

## Requirements

- Terraform ≥ 1.12.1
- AzureCAF Provider ~> 1.2.0
- AzureAPI Provider ~> 2.0.0
- Azure CLI (latest version recommended)
- An active Azure subscription

## How to Use

DevFactory is designed with a modular approach. The root module (main.tf) is the entry point that orchestrates the creation of all resources, and you provide different variable files to control what gets deployed:

```bash
# Login to Azure
az login

# Initialize Terraform
terraform init

# Deploy a simple resource group configuration
terraform plan -var-file=examples/resource_group/simple_case/configuration.tfvars
terraform apply -var-file=examples/resource_group/simple_case/configuration.tfvars

# Deploy a dev center with devboxes
terraform plan -var-file=examples/dev_center/simple_case/configuration.tfvars
terraform apply -var-file=examples/dev_center/simple_case/configuration.tfvars
```

For more complex scenarios, check out the examples in the `examples` directory. Each example demonstrates a specific use case and can be used as a starting point for your own configurations.

## Testing

DevFactory includes a comprehensive test suite with unit and integration tests to validate all modules. For detailed testing instructions, including how to run tests, write new tests, and troubleshoot common issues, see the [Testing Guide](docs/testing.md).

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
