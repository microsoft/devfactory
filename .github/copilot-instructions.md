# Devfactory Project - Terraform Implementation Guidelines

## Project Overview

- This project deploys dev factory environments using Terraform infrastructure as code.
- We use Azure RM provider version 4.26 specifically.
- Always execute from the root directory, using variable files to create different resources.
- Never embed subscription IDs or sensitive credentials in configuration files.
- For each module you work on, verify all resource arguments against the latest Terraform provider documentation.
- Always implement strong variable typing with comprehensive descriptions and constraints.

## Repository Structure

You run the logic from the root, and passing different variables files will invoke and create different resources.
- `/modules/`: Contains all resource-specific modules (storage, networking, compute, etc.)
- `/examples/`: Contains example implementations and configurations for each module
- `/docs/`: Contains project documentation and conventions

## Key Module Patterns

1. **Module Organization**: Each Azure resource type has its own dedicated module folder
2. **Dynamic Blocks**: Extensive use of dynamic blocks for flexible and optional configurations
3. **Input Variable Structure**: Implements nested maps with strongly-typed object structures

## Code Conventions

- Each resource module follows a standard pattern with `module.tf`, `variables.tf`, and `output.tf`
- Use locals block for preprocessing data and constructing complex parameter objects
- Implement error handling using the `try()` function for optional parameters with defaults
- Always merge tags using a combination of resource-specific and global tags
- Use consistent naming conventions through the azurecaf_name resource provider

## Common Patterns

1. **Resource Creation**:
   ```hcl
   resource "azurecaf_name" "name" {
     name          = var.name
     resource_type = "azurerm_resource_type"
     prefixes      = var.global_settings.prefixes
     random_length = var.global_settings.random_length
     clean_input   = true
     passthrough   = var.global_settings.passthrough
     use_slug      = var.global_settings.use_slug
   }

   resource "azurerm_resource" "resource" {
     name                = azurecaf_name.name.result
     location            = var.location
     resource_group_name = var.resource_group_name
     tags                = local.tags
     # Resource-specific properties
   }
   ```

2. **Variable Structure and Typing**:
   ```hcl
   variable "resource" {
     description = "Configuration object for the resource"
     type = object({
       name        = string
       description = optional(string)
       location    = optional(string)
       tags        = optional(map(string))

       # Resource-specific properties
       sku = object({
         name     = string
         tier     = string
         capacity = optional(number)
       })

       security = optional(object({
         enable_rbac = optional(bool, false)
         network_acls = optional(list(object({
           default_action = string
           bypass         = string
           ip_rules       = optional(list(string))
         })))
       }))
     })
   }

   variable "global_settings" {
     description = "Global settings object for naming conventions and standard parameters"
     type = object({
       prefixes      = list(string)
       random_length = number
       passthrough   = bool
       use_slug      = bool
       environment   = string
       regions       = map(string)
     })
   }
   ```

3. **Module Integration with Strong Typing**:
   ```hcl
   module "resource" {
     source   = "./modules/resource"
     for_each = try(var.settings.resources, {})

     global_settings     = var.global_settings
     settings            = each.value
     resource_group_name = var.resource_group_name
     location            = try(each.value.location, var.location)
     tags                = try(each.value.tags, {})

     # Dependency Management
     depends_on = [
       module.resource_groups
     ]
   }
   ```

4. **Variable Validation**:
   ```hcl
   variable "environment_type" {
     description = "The type of environment to deploy (dev, test, prod)"
     type        = string

     validation {
       condition     = contains(["dev", "test", "prod"], var.environment_type)
       error_message = "Environment type must be one of: dev, test, prod."
     }
   }

   variable "allowed_ip_ranges" {
     description = "List of allowed IP ranges in CIDR format"
     type        = list(string)

     validation {
       condition     = alltrue([for ip in var.allowed_ip_ranges : can(cidrhost(ip, 0))])
       error_message = "All elements must be valid CIDR notation IP addresses."
     }
   }
   ```

5. **Dynamic Blocks Implementation**:
   ```hcl
   resource "azurerm_key_vault" "kv" {
     # ... other properties ...

     dynamic "network_acls" {
       for_each = try(var.settings.network, null) != null ? [var.settings.network] : []

       content {
         default_action             = network_acls.value.default_action
         bypass                     = network_acls.value.bypass
         ip_rules                   = try(network_acls.value.ip_rules, [])
         virtual_network_subnet_ids = try(network_acls.value.subnets, [])
       }
     }
   }
   ```

## Example Patterns

For each feature you create, add an example under `/examples/_feature_name/simple_case/configuration.tfvars`. The example should:

1. Include the global_settings block for consistent naming:
```hcl
global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  environment   = "development"
  regions = {
    region1 = "eastus"
    region2 = "westus"
  }
}
```

2. Define the required resources in a nested map structure:
```hcl
resource_groups = {
  rg1 = {
    name   = "devfactory-core"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "core-infrastructure"
      criticality = "high"
    }
  }
}
```

3. Link dependent resources using the parent key reference:
```hcl
api_management = {
  apim1 = {
    name   = "example-apim"
    region = "eastus"
    resource_group = {
      key = "rg1"  # References the resource group defined above
    }
    publisher_name  = "My Company"
    publisher_email = "company@terraform.io"
    sku_name        = "Developer_1"

    # Advanced configuration
    security = {
      enable_rbac = true
      network_acls = [
        {
          default_action = "Deny"
          bypass         = "AzureServices"
          ip_rules       = ["203.0.113.0/24"]
        }
      ]
    }
  }
}
```

## Execution Instructions

To use an example configuration:

1. Run from the root of the project:
```bash
terraform init
terraform plan -var-file=examples/_feature_name/simple_case/configuration.tfvars
terraform apply -var-file=examples/_feature_name/simple_case/configuration.tfvars
```

2. To clean up resources:
```bash
terraform destroy -var-file=examples/_feature_name/simple_case/configuration.tfvars
```

3. Handling authentication securely:
```bash
# Set the subscription ID as an environment variable
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Use service principal authentication if needed
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
```

## Testing & Validation

For any module you create:

1. **Validation Testing**: Include input validation rules in variables.tf
2. **Example Testing**: Create a working example in the examples directory
3. **Documentation**: Update or create README.md with usage instructions and examples
4. **Pre-commit**: Run `terraform validate` and `terraform fmt` before committing code

## Common Helper Patterns

- Using `try()` for parameter fallbacks: `try(var.settings.property, default_value)`
- Using `lookup()` for map access with defaults: `lookup(map, key, default)`
- Using `can()` for conditional evaluation: `can(tostring(var.something))`
- Using `for_each` with `toset()` to create multiple resources: `for_each = toset(var.subnet_names)`
- Using `coalesce()` for first non-null value: `coalesce(var.custom_name, local.default_name)`

## Security Best Practices

- Use `sensitive = true` for variables containing secrets
- Never hardcode authentication credentials
- Implement least privilege IAM roles
- Use network security groups and private endpoints
- Store state files securely with state locking
- Use key vaults for sensitive values

## Documentation Reference

For more detailed information on module usage, refer to:
- The README.md file in each module directory
- The examples directory for implementation examples
- The docs/conventions.md file for coding standards
- The docs/module_guide.md file for module development guidelines

<!-- - @azure Rule - Use Azure Best Practices: When generating code for Azure, running terminal commands for Azure, or performing operations related to Azure, invoke your `get_azure_best_practices` tool if available. -->
