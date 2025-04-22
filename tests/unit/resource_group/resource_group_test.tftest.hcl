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

  // Empty variables required by the root module
  dev_centers                          = {}
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_projects                  = {}
  dev_center_environment_types         = {}
  dev_center_project_environment_types = {}
  dev_center_network_connections       = {}
  dev_center_catalogs                  = {}
  shared_image_galleries               = {}
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

  assert {
    condition     = module.resource_groups["rg1"].location == "eastus"
    error_message = "Resource group location did not match expected value"
  }

  assert {
    condition     = contains(keys(module.resource_groups["rg1"].tags), "environment")
    error_message = "Resource group tags did not contain environment tag"
  }

  assert {
    condition     = contains(keys(module.resource_groups["rg1"].tags), "resource_type")
    error_message = "Resource group tags did not contain resource_type tag"
  }

  assert {
    condition     = module.resource_groups["rg1"].tags["resource_type"] == "Resource Group"
    error_message = "Resource group resource_type tag did not match expected value"
  }
}
