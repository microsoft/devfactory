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

  dev_center_projects = {
    project1 = {
      name = "test-project"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      description                = "Test project description"
      maximum_dev_boxes_per_user = 3
      tags = {
        environment = "test"
        module      = "dev_center_project"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_environment_types         = {}
  dev_center_project_environment_types = {}
  dev_center_network_connections       = {}
  dev_center_catalogs                  = {}
  shared_image_galleries               = {}
}

mock_provider "azurerm" {}

run "project_creation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_projects["project1"].name != ""
    error_message = "Project name should not be empty"
  }

  assert {
    condition     = module.dev_center_projects["project1"].location == module.resource_groups["rg1"].location
    error_message = "Project location did not match expected value"
  }

  assert {
    condition     = module.dev_center_projects["project1"].resource_group_name == module.resource_groups["rg1"].name
    error_message = "Project resource group name did not match expected value"
  }

  assert {
    condition     = startswith(module.dev_center_projects["project1"].dev_center_id, "/subscriptions/")
    error_message = "Project dev center ID should be a valid Azure resource ID"
  }

  assert {
    condition     = module.dev_center_projects["project1"].description == "Test project description"
    error_message = "Project description did not match expected value"
  }

  assert {
    condition     = module.dev_center_projects["project1"].maximum_dev_boxes_per_user == 3
    error_message = "Project maximum dev boxes per user did not match expected value"
  }

  assert {
    condition     = contains(keys(module.dev_center_projects["project1"].tags), "environment")
    error_message = "Project tags did not contain environment tag"
  }

  assert {
    condition     = contains(keys(module.dev_center_projects["project1"].tags), "module")
    error_message = "Project tags did not contain module tag"
  }
}
