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

  dev_center_environment_types = {
    envtype1 = {
      name = "test-environment-type"
      dev_center = {
        key = "devcenter1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_environment_type"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_projects                  = {}
  dev_center_project_environment_types = {}
  dev_center_network_connections       = {}
  dev_center_catalogs                  = {}
  shared_image_galleries               = {}
}

mock_provider "azurerm" {}

run "environment_type_creation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_environment_types["envtype1"].name != ""
    error_message = "Environment type name should not be empty"
  }

  assert {
    condition     = startswith(module.dev_center_environment_types["envtype1"].dev_center_id, "/subscriptions/")
    error_message = "Environment type dev center ID should be a valid Azure resource ID"
  }

  assert {
    condition     = contains(keys(module.dev_center_environment_types["envtype1"].tags), "environment")
    error_message = "Environment type tags did not contain environment tag"
  }

  assert {
    condition     = contains(keys(module.dev_center_environment_types["envtype1"].tags), "module")
    error_message = "Environment type tags did not contain module tag"
  }
}
