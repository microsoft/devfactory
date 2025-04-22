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
      identity = {
        type = "SystemAssigned"
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
  dev_center_project_environment_types = {}
  dev_center_network_connections       = {}
  dev_center_catalogs                  = {}
  shared_image_galleries               = {}
}

mock_provider "azurerm" {}

run "full_infrastructure_creation" {
  command = plan

  module {
    source = "../../"
  }

  // Test resource group creation
  assert {
    condition     = module.resource_groups["rg1"].name != ""
    error_message = "Resource group name should not be empty"
  }

  // Test dev center creation
  assert {
    condition     = module.dev_centers["devcenter1"].name != ""
    error_message = "Dev center name should not be empty"
  }

  // Test dev center project creation
  assert {
    condition     = module.dev_center_projects["project1"].name != ""
    error_message = "Project name should not be empty"
  }

  // Test dev center environment type creation
  assert {
    condition     = module.dev_center_environment_types["envtype1"].name != ""
    error_message = "Environment type name should not be empty"
  }

  // Test relationships between resources
  assert {
    condition     = module.dev_centers["devcenter1"].resource_group_name == module.resource_groups["rg1"].name
    error_message = "Dev center resource group name did not match expected resource group name"
  }

  assert {
    condition     = startswith(module.dev_center_projects["project1"].dev_center_id, "/subscriptions/")
    error_message = "Project dev center ID was not properly formed"
  }

  assert {
    condition     = startswith(module.dev_center_environment_types["envtype1"].dev_center_id, "/subscriptions/")
    error_message = "Environment type dev center ID was not properly formed"
  }
}
