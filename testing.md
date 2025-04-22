# Testing Guide for DevFactory

This guide provides information about testing the Terraform modules and examples in the DevFactory repository.

## Testing Approach

DevFactory uses Terraform's native testing functionality to verify that modules correctly create resources with the expected properties and that modules work together as intended. The tests use provider mocking to avoid creating real Azure resources during testing.

## Test Structure

The tests are organized into three main categories:

- **Unit Tests**: Test individual modules in isolation
- **Integration Tests**: Test the interaction between multiple modules
- **Example Tests**: Test the example configurations provided in the repository

The test directory structure is as follows:

```
tests/
├── README.md
├── examples/
│   ├── dev_center_project_test.tftest.hcl
│   └── dev_center_system_assigned_identity_test.tftest.hcl
├── integration/
│   └── dev_center_integration_test.tftest.hcl
└── unit/
    ├── dev_center/
    │   └── dev_center_test.tftest.hcl
    ├── dev_center_environment_type/
    │   └── environment_type_test.tftest.hcl
    ├── dev_center_project/
    │   └── project_test.tftest.hcl
    └── resource_group/
        └── resource_group_test.tftest.hcl
```

## Running Tests

### Running All Tests

To run all tests in the repository, use the provided script in the tests folder:

```bash
./tests/run_tests.sh
```

This script will run all tests in the repository and display the results.

### Running Individual Tests

To run a specific test, use the `terraform test` command with the path to the test file:

```bash
terraform test tests/unit/resource_group/resource_group_test.tftest.hcl
```

## Test Mocking

The tests use Terraform's provider mocking capabilities to avoid creating real Azure resources during testing. The `azurerm` provider is mocked to return predefined values, while the `azurecaf` provider is used directly.

Example of provider mocking in a test file:

```hcl
mock_provider "azurerm" {}
```

## Writing Tests

### Unit Tests

Unit tests verify that individual modules create resources with the expected properties. Each unit test focuses on a single module and tests its functionality in isolation.

Example of a unit test for the resource_group module:

```hcl
variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  resource_groups = {
    rg1 = {
      name   = "test-resource-group"
      region = "eastus"
      tags = {
        environment = "test"
      }
    }
  }
}

mock_provider "azurerm" {}

run "resource_group_creation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.resource_groups["rg1"].name != ""
    error_message = "Resource group name should not be empty"
  }
}
```

### Integration Tests

Integration tests verify that multiple modules work together correctly. These tests create a complete infrastructure and test the relationships between resources.

Example of an integration test:

```hcl
variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  resource_groups = {
    rg1 = {
      name   = "test-resource-group"
      region = "eastus"
      tags = {
        environment = "test"
      }
    }
  }

  dev_centers = {
    devcenter1 = {
      name = "test-dev-center"
      resource_group = {
        key = "rg1"
      }
      tags = {
        environment = "test"
        module      = "dev_center"
      }
    }
  }
}

mock_provider "azurerm" {}

run "full_infrastructure_creation" {
  command = plan

  module {
    source = "../../"
  }

  assert {
    condition     = module.resource_groups["rg1"].name != ""
    error_message = "Resource group name should not be empty"
  }

  assert {
    condition     = module.dev_centers["devcenter1"].name != ""
    error_message = "Dev center name should not be empty"
  }
}
```

### Example Tests

Example tests verify that the example configurations provided in the repository work as expected. These tests use the example configuration files and test the resulting infrastructure.

Example of an example test:

```hcl
variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }
}

mock_provider "azurerm" {}

run "dev_center_project_example" {
  command = plan

  module {
    source = "../../"
  }

  variables {
    file = "../../examples/dev_center_project/configuration.tfvars"
  }

  assert {
    condition     = module.resource_groups["rg1"].name != ""
    error_message = "Resource group name was empty"
  }
}
```

## Best Practices

When writing tests for DevFactory, follow these best practices:

1. **Mock the azurerm provider**: Use provider mocking to avoid creating real Azure resources during testing.
2. **Use the azurecaf provider directly**: The azurecaf provider should be used directly, not mocked.
3. **Test resource properties**: Verify that resources are created with the expected properties.
4. **Test resource relationships**: Verify that resources are correctly associated with each other.
5. **Include assertions**: Each test should include assertions to verify the expected behavior.
6. **Follow the existing pattern**: When adding new tests, follow the existing pattern for unit and integration tests.

## Troubleshooting

If you encounter issues when running tests, check the following:

1. **Terraform version**: Ensure you are using Terraform version 1.9.0 or higher.
2. **Provider versions**: Ensure you are using the correct provider versions.
3. **Test file structure**: Ensure the test file follows the correct structure.
4. **Module source**: Ensure the module source is correctly specified.
5. **Variable definitions**: Ensure all required variables are defined.
