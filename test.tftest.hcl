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

run "basic_test" {
  command = plan

  assert {
    condition     = length(var.resource_groups) > 0
    error_message = "Resource groups variable should not be empty"
  }

  assert {
    condition     = length(var.dev_centers) > 0
    error_message = "Dev centers variable should not be empty"
  }
}
