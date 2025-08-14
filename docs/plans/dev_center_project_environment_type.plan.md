# Implementation Plan for Dev Center Project Environment Type Module

## Overview

This plan outlines the implementation of the `dev_center_project_environment_type` module for DevFactory. This module creates associations between Dev Center projects and environment types, enabling specific environment types to be available within projects.

The module will follow DevFactory patterns and use AzAPI provider v2.4.0 with the Azure DevCenter API version 2025-04-01-preview.

## Implementation Steps

- [x] **Step 1: Create Module Infrastructure**
  - **Task**: Create the core module structure and files for dev_center_project_environment_type following DevFactory patterns
  - **Files**:
    - `modules/dev_center_project_environment_type/module.tf`: Main module implementation with azapi_resource for Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview
    - `modules/dev_center_project_environment_type/variables.tf`: Input variable definitions with strong typing and validation
    - `modules/dev_center_project_environment_type/output.tf`: Output definitions for project environment type properties
    - `modules/dev_center_project_environment_type/README.md`: Module documentation with usage examples
  - **Dependencies**: AzAPI provider v2.4.0, azurecaf provider for naming
  - **Pseudocode**:

    ```hcl
    resource "azapi_resource" "dev_center_project_environment_type" {
      type      = "Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview"
      name      = var.project_environment_type.environment_type.name
      parent_id = var.dev_center_project_id
      body = {
        properties = {
          deploymentTargetId = var.deployment_target_id
          status = try(var.project_environment_type.status, "Enabled")
          userRoleAssignments = try(var.project_environment_type.user_role_assignments, {})
        }
        tags = local.tags
      }
    }
    ```

- [ ] **Step 2: Create Root Orchestration File**
  - **Task**: Create the root-level orchestration file to manage project environment types across all Dev Center projects
  - **Files**:
    - `dev_center_project_environment_types.tf`: Root orchestration calling the project environment type module for each configuration
  - **Dependencies**: dev_center_project_environment_type module, dev_center_projects module for references
  - **Pseudocode**:

    ```hcl
    module "dev_center_project_environment_types" {
      source   = "./modules/dev_center_project_environment_type"
      for_each = var.dev_center_project_environment_types

      global_settings          = var.global_settings
      project_environment_type = each.value
      dev_center_project_id    = module.dev_center_projects[each.value.project.key].id
      deployment_target_id     = each.value.deployment_target_id
    }
    ```

- [ ] **Step 3: Add Variable Definition to Root Variables**
  - **Task**: Add the dev_center_project_environment_types variable to the root variables.tf file
  - **Files**:
    - `variables.tf`: Add new variable definition with proper typing and validation
  - **Dependencies**: Existing variable patterns
  - **Pseudocode**:

    ```hcl
    variable "dev_center_project_environment_types" {
      description = "Dev Center Project Environment Types configuration objects"
      type = map(object({
        name = string
        project = object({
          key = string
        })
        environment_type = object({
          key = string
        })
        deployment_target_id = string
        status = optional(string, "Enabled")
        user_role_assignments = optional(map(object({
          roles = list(string)
        })))
        tags = optional(map(string), {})
      }))
      default = {}
    }
    ```

- [x] **Step 4: Create Examples**
  - **Task**: Create example configurations for different use cases
  - **Files**:
    - `examples/dev_center_project_environment_type/simple_case/configuration.tfvars`: Basic example with minimal configuration
    - `examples/dev_center_project_environment_type/enhanced_case/configuration.tfvars`: Advanced example with user role assignments
  - **Dependencies**: Existing example patterns, dev_center and project examples
  - **Pseudocode**: Create example configurations that demonstrate linking environment types to projects

- [ ] **Step 5: Create Unit Tests**
  - **Task**: Implement comprehensive unit tests for the project environment type module using Terraform's native testing
  - **Files**:
    - `tests/unit/dev_center_project_environment_type/project_environment_type_test.tftest.hcl`: Main unit test file with provider mocking
  - **Dependencies**: Terraform test framework, mock providers
  - **Pseudocode**:

    ```hcl
    run "test_project_environment_type_creation" {
      command = plan
      
      variables {
        project_environment_type = {
          name = "test-project-env-type"
        }
        dev_center_project_id = "/subscriptions/test/resourceGroups/test/providers/Microsoft.DevCenter/projects/test"
        deployment_target_id = "/subscriptions/test/resourceGroups/test/providers/Microsoft.DevCenter/projects/test/environmentTypes/test"
      }
      
      assert {
        condition = azapi_resource.dev_center_project_environment_type.type == "Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview"
      }
    }
    ```

- [x] **Step 6: Update Integration Tests**
  - **Task**: Update existing integration tests to validate project environment type functionality and relationships
  - **Files**:
    - `tests/integration/dev_center_integration_test.tftest.hcl`: Include project environment type creation and relationship validation
  - **Dependencies**: Existing integration test infrastructure
  - **Pseudocode**: Verify that project environment types are properly created and linked to projects and environment types

- [ ] **Step 7: Update VS Code Tasks Configuration**
  - **Task**: Add project environment type examples to VS Code tasks for easy testing and development
  - **Files**:
    - `.vscode/tasks.json`: Add devCenterProjectEnvironmentType input options for both simple and enhanced cases
  - **Dependencies**: Existing task configuration patterns
  - **Pseudocode**: Add input picker for project environment type example selection

- [x] **Step 8: Update Documentation**
  - **Task**: Update project documentation to include project environment type module information
  - **Files**:
    - `docs/file_structure.md`: Update with project environment type module and example locations
    - `docs/module_guide.md`: Add comprehensive project environment type usage patterns and configuration options
  - **Dependencies**: Existing documentation standards
  - **Pseudocode**: Add project environment type section with usage examples and configuration reference

- [ ] **Step 9: Validation and Testing**
  - **Task**: Run comprehensive validation to ensure the implementation meets requirements
  - **Files**: All created files validated successfully
  - **Dependencies**: Terraform validation tools, test framework
  - **Steps**:
    - Run `terraform fmt` to ensure consistent formatting
    - Run `terraform validate` to check syntax and configuration
    - Execute unit tests to verify module functionality
    - Execute integration tests to validate project environment type relationships
    - Test example configurations to ensure they work correctly
    - Verify VS Code tasks work with new examples

## Validation Criteria

- All files follow DevFactory conventions and patterns
- Module uses AzAPI provider v2.4.0 exclusively
- Strong typing and validation for all variables
- Comprehensive test coverage (unit and integration)
- Working examples for different use cases
- Complete documentation including README and module guide
- VS Code tasks integration for development workflow
- Successful terraform fmt, validate, and test execution

## Risk Mitigation

- **API Version Compatibility**: Use 2025-04-01-preview which supports the latest DevCenter features
- **Breaking Changes**: Follow existing patterns from dev_center_environment_type module for consistency
- **Testing Coverage**: Implement both unit and integration tests to ensure reliability
- **Documentation**: Provide comprehensive documentation and examples to ensure usability

## User Intervention Required

- Review and approve the implementation plan
- Provide feedback on any specific requirements or constraints
- Validate that the chosen API version and properties meet business requirements
- Test the implemented examples to ensure they meet real-world use cases