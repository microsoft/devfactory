# Dev Center Project Simple Example

This example demonstrates the basic usage of the dev_center_project module with minimal configuration.

## Configuration

```hcl
global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "demo"
    created_by  = "terraform"
  }
}

resource_groups = {
  rg1 = {
    name   = "devfactory-simple"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name = "simple-devcenter"
    resource_group = {
      key = "rg1"
    }
    identity = {
      type = "SystemAssigned"
    }
  }
}

dev_center_projects = {
  project1 = {
    name = "simple-project"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "Simple development project"
    maximum_dev_boxes_per_user = 2

    tags = {
      module = "dev_center_project"
      tier   = "basic"
    }
  }
}
```

## Usage

1. Ensure you're authenticated to Azure:
   ```bash
   az login
   export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
   ```

2. Initialize and apply:
   ```bash
   terraform init
   terraform plan -var-file=examples/dev_center_project/simple_case/configuration.tfvars
   terraform apply -var-file=examples/dev_center_project/simple_case/configuration.tfvars
   ```

3. Clean up:
   ```bash
   terraform destroy -var-file=examples/dev_center_project/simple_case/configuration.tfvars
   ```

## Resources Created

This example creates:
- 1 Resource Group
- 1 Dev Center with system-assigned identity
- 1 Dev Center Project with basic configuration

## Notes

- Uses system-assigned managed identity for the Dev Center
- Sets a maximum of 2 Dev Boxes per user
- Uses default settings for all optional features (disabled)
- Demonstrates the minimum required configuration
