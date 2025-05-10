# Devfactory Project - Terraform Implementation Guidelines

## Quick Reference Summary

- **Provider:** AzureRM v4.26 only
- **Run Location:** Always from project root
- **Sensitive Data:** Never hardcode credentials or subscription IDs
- **Module Verification:** Always check resource arguments against latest provider docs
- **Variable Typing:** Use strong types, descriptions, and constraints
- **Examples:** Every resource/module must have an example in `/examples/`
- **Validation:** Run `terraform fmt` and `terraform validate` before commit

---

## DO
- Use only AzureRM provider version 4.26
- Place all resource modules in `/modules/` and examples in `/examples/`
- Use dynamic blocks for optional/flexible config
- Use nested maps and strongly-typed objects for variables
- Use `locals` for preprocessing and complex parameter objects
- Use `try()` for error handling and parameter fallbacks
- Merge tags (resource-specific + global)
- Use `azurecaf_name` for naming conventions
- Add input validation in `variables.tf`
- Add a working example for every resource/module
- Update module README.md with usage and examples
- Reference provider docs for every resource: https://registry.terraform.io/providers/hashicorp/azurerm/4.26.0/docs/resources/<resource>

## DO NOT
- Do not embed subscription IDs or credentials in code/config
- Do not use untyped or weakly-typed variables
- Do not skip example creation for new/changed resources
- Do not commit without running `terraform fmt` and `terraform validate`
- Do not use provider versions other than 4.26

---

## Repository Structure
- `/modules/`: Resource-specific modules (storage, networking, compute, etc.)
- `/examples/`: Example implementations/configurations for each module
- `/docs/`: Project documentation and conventions

---

## Key Module Patterns
- Each Azure resource type in its own module folder
- Use dynamic blocks for optional/flexible config
- Input variables: nested maps, strongly-typed objects

---

## Code Conventions
- Each module: `module.tf`, `variables.tf`, `output.tf`
- Use `locals` for preprocessing/complex objects
- Use `try()` for optional/defaulted params
- Merge tags (resource + global)
- Use `azurecaf_name` for naming

---

## Common Patterns

**Resource Creation:**
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

**Variable Structure and Typing:**
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

**Module Integration with Strong Typing:**
```hcl
module "resource" {
  source   = "./modules/resource"
  for_each = try(var.settings.resources, {})
  global_settings     = var.global_settings
  settings            = each.value
  resource_group_name = var.resource_group_name
  location            = try(each.value.location, var.location)
  tags                = try(each.value.tags, {})
  depends_on = [
    module.resource_groups
  ]
}
```

**Variable Validation:**
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

**Dynamic Blocks Implementation:**
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

---

## Example Patterns
- Add an example for each feature under `/examples/_feature_name/simple_case/configuration.tfvars`
- Include a `global_settings` block for naming
- Define resources in nested map structure
- Link dependent resources using parent key reference

---

## Execution Instructions
- Run from root:
  ```bash
  terraform init
  terraform plan -var-file=examples/_feature_name/simple_case/configuration.tfvars
  terraform apply -var-file=examples/_feature_name/simple_case/configuration.tfvars
  ```
- Destroy resources:
  ```bash
  terraform destroy -var-file=examples/_feature_name/simple_case/configuration.tfvars
  ```
- Set authentication via environment variables (never in code):
  ```bash
  export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
  export ARM_CLIENT_ID="your-client-id"
  export ARM_CLIENT_SECRET="your-client-secret"
  export ARM_TENANT_ID="your-tenant-id"
  ```

---

## Testing & Validation
- Add input validation in `variables.tf`
- Add a working example in `/examples/`
- Update module README.md with usage and examples
- Run `terraform validate` and `terraform fmt` before commit

---

## Common Helper Patterns
- `try(var.settings.property, default_value)` for fallbacks
- `lookup(map, key, default)` for map access
- `can(tostring(var.something))` for conditional evaluation
- `for_each = toset(var.subnet_names)` for multiple resources
- `coalesce(var.custom_name, local.default_name)` for first non-null value

---

## Security Best Practices
- Use `sensitive = true` for secret variables
- Never hardcode credentials
- Use least privilege IAM roles
- Use NSGs and private endpoints
- Store state files securely with locking
- Use key vaults for sensitive values

---

## Documentation Reference
- See README.md in each module
- See `/examples/` for implementation
- See `docs/conventions.md` for standards
- See `docs/module_guide.md` for module development
- Always verify resource arguments at: https://registry.terraform.io/providers/hashicorp/azurerm/4.26.0/docs/resources/<resource>

---

## AI Assistant Prompt Guidance
- When asked to generate Terraform code, always:
  - Use AzureRM provider v4.26
  - Use strong typing and validation for variables
  - Add an example in `/examples/`
  - Reference provider documentation for all arguments
  - Never include credentials or subscription IDs in code
  - Use dynamic blocks and locals as shown above
  - Follow naming conventions with `azurecaf_name`
  - Add input validation and documentation
  - Use only patterns and helpers listed above

---

This dev container includes the Azure CLI, GitHub CLI, Terraform CLI, TFLint, and Terragrunt pre-installed and available on the PATH, along with the Terraform and Azure extensions for development.
