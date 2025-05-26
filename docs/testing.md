# Testing Guide for DevFactory

This document describes how to run tests in the DevFactory project.

## Test Structure

The DevFactory project uses Terraform's built-in testing framework. Tests are organized as follows:

```
tests/
├── integration/             # Integration tests that test multiple modules together
│   └── dev_center_integration_test.tftest.hcl
└── unit/                    # Unit tests for individual modules
    ├── dev_center/
    │   └── dev_centers_test.tftest.hcl
    ├── dev_center_environment_type/
    │   └── environment_type_test.tftest.hcl
    ├── dev_center_project/
    │   └── project_test.tftest.hcl
    └── resource_group/
        └── resource_group_test.tftest.hcl
```

## Test Types

### Unit Tests

Unit tests validate individual modules in isolation:

- **Resource Group**: Tests basic resource group creation and custom tags
- **Dev Center**: Tests various identity configurations (System, User, and combined)
- **Environment Type**: Tests environment type creation with various configurations
- **Project**: Tests project creation with basic and custom properties

### Integration Tests

Integration tests validate the interaction between multiple modules, ensuring they work together correctly.

## Running Tests

### Prerequisites

- Terraform v1.12.1 or higher
- Provider configurations for Azure and AzureCAF

### Running Tests

#### Using Command Line

To run all tests in the repository, use the provided script:

```bash
./tests/run_tests.sh
```

This script will run all tests in the repository and display the results.

#### Using VS Code Tasks

You can also run tests directly from VS Code using the built-in tasks:

1. Open the Command Palette (⇧⌘P on macOS or Ctrl+Shift+P on Windows/Linux)
2. Type "Tasks: Run Task" and select it
3. Choose "Terraform: Run All Tests" to run all tests

This will execute the same script but provides a convenient way to run tests without leaving the editor.

### Running Individual Tests

To run a specific test, you need to initialize the test directory first and then run the test:

```bash
# Initialize the test directory
terraform -chdir=tests/unit/resource_group init

# Run the test
terraform -chdir=tests/unit/resource_group test
```

### Running All Tests

You can use the provided script to run all tests:

```bash
./tests/run_tests.sh
```

### Running Tests with Verbose Output

To see more details during test execution:

```bash
terraform -chdir=tests/unit/resource_group test -verbose
```

### Testing Specific Test Runs

To run a specific test run block within a test file:

```bash
terraform -chdir=tests/unit/resource_group test run "test_basic_resource_group"
```

## Writing Tests

### Test File Structure

Each test file follows this structure:

```hcl
variables {
  # Test variables defined here
}

mock_provider "..." {
  # Provider mock configurations
}

run "test_name" {
  command = plan  # or apply

  variables {
    # Test-specific variable overrides
  }

  module {
    source = "../../../"  # Path to the module being tested
  }

  assert {
    condition     = module.resource_name != null
    error_message = "Error message"
  }
}
```

### Best Practices

1. **Use Mocks**: Always use mock providers in tests to avoid real resource creation
2. **Test Multiple Configurations**: Test both basic and advanced configurations
3. **Keep Assertions Focused**: For `plan` tests, only assert on values available during planning
4. **Use Plan First**: Start with `plan` tests, then add `apply` tests if needed
5. **Verify Missing Items**: Add assertions to verify resources should exist

## Common Issues and Solutions

- **Unknown Values in Plan**: When using `command = plan`, only assert on values that are known during planning
- **Initialization Issues**: Ensure each test directory is properly initialized before running tests
- **Provider Versions**: Make sure provider versions are compatible with your Terraform version

## Continuous Integration

Tests are automatically run in CI pipelines. You can check the CI configuration for details.
