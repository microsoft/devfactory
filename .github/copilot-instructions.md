## Devfactory project 

- This project deploys dev factory environment using Terraform.
- We use azurerm provider 4.26.
- Never create a side test file, always use the root as entry point and the variables to create different resources.

## Repository Structure
You run the logic from the root, and passing different variables files will invoke and create different resources.
- `/modules/`: Contains all resource-specific modules (storage, networking, compute, etc.)
- `/examples/`: Contains example implementations and configurations for each of the module implemented
- `/documentation/`: Contains project documentation and conventions

## Key Module Patterns
1. **Module Organization**: Each Azure resource type has its own module folder
2. **Dynamic Blocks**: Extensive use of dynamic blocks for optional configurations
3. **Input Variable Structure**: Follows a nested map with complext object structure for input variables

## Code Conventions
- Each resource module uses a standard pattern with `module.tf`, `variables.tf`, and `output.tf`
- Modules follow a common pattern with locals for preprocessing and resource blocks
- Resources use the `try()` function for handling optional parameters with defaults
- Tags are consistently merged using a combination of resource-specific and global tags

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

2. **Variable Structure**:
Try to do strong object typing as much as possible. 
   ```hcl
   variable "resource" {
     description = "Configuration object for the resource"
   }
   
   variable "global_settings" {
     description = "Global settings object"
   }
   ```

3. **Module Integration**:
   ```hcl
   module "resource" {
     source   = "./resource"
     for_each = try(var.settings.resources, {})
     
     global_settings     = var.global_settings
     settings            = each.value
     resource_group_name = var.resource_group_name
     # Other parameters
   }
   ```

4. **Add examples for testing and usability**:
For each feature you create, add an example with its name under /examples/_feature_name/simple_case to consume the variables like: 

```hcl
resource_groups = {
  rg1 = {
    name   = "example-agw"
    region = "region1"
  }
}

api_management = {
  apim1 = {
    name   = "example-apim"
    region = "region1"
    resource_group = {
      key = "rg1"
    }
    publisher_name  = "My Company"
    publisher_email = "company@terraform.io"

    sku_name = "Developer_1"
    tags = {
      project = "demo"
    }
  }
}
```

5. Resources association

a. Each resource will be associated with another either:
- by passing a resource_id
- by associating his parent key for example:
```hcl
resource_groups = {
  rg1 = {
    name   = "example-agw"
    region = "region1"
  }
}

api_management = {
  apim1 = {
    name   = "example-apim"
    region = "region1"
    resource_group = {
      key = "rg1"
    }
```

## Common Helper Patterns
- Using `try()` for parameter fallbacks
- Using `lookup()` to safely access map values
- Using `can()` to check if a value can be determined
- Using `for_each` with nested maps for creating multiple resources

## Documentation Reference
For more detailed information on module usage, refer to:
- The README.md file in each module directory
- The examples directory for implementation examples
- The documentation/conventions.md file for coding standards


- @azure Rule - Use Azure Best Practices: When generating code for Azure, running terminal commands for Azure, or performing operations related to Azure, invoke your `get_azure_best_practices` tool if available.