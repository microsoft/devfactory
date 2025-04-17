# DevFactory Coding Conventions

This document outlines the coding conventions and best practices for the DevFactory project.

## Terraform Code Structure

### File Organization
Each resource module follows a consistent file structure:
- `module.tf` - Contains the main resource definitions
- `variables.tf` - Contains input variable declarations
- `output.tf` - Contains output variable declarations

### Naming Conventions

1. **Resource Naming**
   - All resources use the Azure CAF naming module for consistent naming
   - Standard prefixes are applied through global settings
   - Resources are named using a combination of prefixes, resource type, and custom name

2. **Variable Naming**
   - Variable names use snake_case
   - Resource-specific variables are grouped under an object with the resource name
   - Common variables like `global_settings`, `resource_group_name`, and `location` are used consistently

### Code Style

1. **Indentation**
   - Use 2 spaces for indentation
   - Align resource attributes for readability

2. **Comments**
   - Add descriptive comments for complex logic
   - Comment blocks of related code

3. **Resource Blocks**
   - Group related resources together
   - Use consistent ordering of resource attributes (name, location, resource group first)

## Input Variable Structure

1. **Global Settings**
   ```hcl
   variable "global_settings" {
     description = "Global settings object"
     type = object({
       prefixes      = optional(list(string))
       random_length = optional(number)
       passthrough   = optional(bool)
       use_slug      = optional(bool)
     })
   }
   ```

2. **Resource Configuration**
   ```hcl
   variable "resource_name" {
     description = "Configuration object for the resource"
     type = object({
       name = string
       # Resource-specific properties
     })
   }
   ```

3. **Resource References**
   ```hcl
   # Direct reference
   resource_id = var.resource_id

   # Key-based reference
   resource = object({
     key = string
   })
   ```

## Common Code Patterns

### Resource Creation Pattern

```hcl
data "azurecaf_name" "resource" {
  name          = var.resource.name
  resource_type = "azurerm_resource_type"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_resource" "resource" {
  name                = data.azurecaf_name.resource.result
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
  # Resource-specific properties
}
```

### Optional Attributes Pattern

```hcl
resource "azurerm_resource" "resource" {
  # Required properties
  name                = data.azurecaf_name.resource.result

  # Optional properties with fallbacks
  property_a         = try(var.resource.property_a, null)
  property_b         = try(var.resource.property_b, "default_value")
  property_c         = lookup(var.resource, "property_c", null)

  # Conditional blocks
  dynamic "block_name" {
    for_each = try(var.resource.block_property, null) != null ? [1] : []
    content {
      # Block properties
    }
  }
}
```

### Tags Merging Pattern

```hcl
locals {
  tags = merge(
    var.tags,
    try(var.resource.tags, {}),
    {
      "resource_type" = "Resource Type"
    }
  )
}
```

### Resource Association Pattern

1. **Direct ID Reference**
```hcl
resource "azurerm_child_resource" "resource" {
  parent_id = var.parent_id
}
```

2. **Key-Based Reference**
```hcl
resource "azurerm_child_resource" "resource" {
  parent_id = module.parent_resources[var.resource.parent.key].id
}
```

## Best Practices

1. **Use the `try()` function** for handling optional parameters
2. **Use `for_each` with map objects** for creating multiple instances of resources
3. **Use `lookup()` to safely access map values** that might not exist
4. **Use `can()` to check if values can be determined** before trying to access them
5. **Use dynamic blocks** for optional configuration sections
6. **Avoid hard-coded values** in resource blocks; use variables instead
7. **Create reusable modules** for common patterns
8. **Validate inputs** using variable type constraints
9. **Use consistent output patterns** across modules
10. **Apply tags consistently** to all resources
