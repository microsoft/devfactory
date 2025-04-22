# Terraform Tests for DevFactory

This directory contains the tests for the Terraform modules in the DevFactory repository.

## Test Structure

The tests are organized into three main categories:

- **Unit Tests**: Test individual modules in isolation
- **Integration Tests**: Test the interaction between multiple modules
- **Example Tests**: Test the example configurations provided in the repository

## Running the Tests

To run all tests:

```bash
cd ~/repos/devfactory
terraform test
```

To run a specific test:

```bash
cd ~/repos/devfactory
terraform test tests/unit/resource_group/resource_group_test.tftest.hcl
```

## Test Mocking

The tests use Terraform's provider mocking capabilities to avoid creating real Azure resources during testing. The `azurerm` and `azurecaf` providers are mocked to return predefined values.

## Adding New Tests

When adding new tests:

1. Follow the existing pattern for unit and integration tests
2. Ensure that the providers are properly mocked
3. Include assertions to verify the expected behavior
