variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  // Empty variables required by the root module
  resource_groups                      = {}
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

run "dev_center_project_example" {
  command = plan

  module {
    source = "../../"
  }

  // Use the tfvars file from the example
  variables {
    file = "../../examples/dev_center_project/configuration.tfvars"
  }

  // Test resource group creation
  assert {
    condition     = module.resource_groups["rg1"].name != ""
    error_message = "Resource group name was empty"
  }

  // Test dev center creation
  assert {
    condition     = module.dev_centers["devcenter1"].name != ""
    error_message = "Dev center name was empty"
  }

  // Test dev center project creation
  assert {
    condition     = module.dev_center_projects["project1"].name != ""
    error_message = "Project name was empty"
  }

  // Test project properties
  assert {
    condition     = module.dev_center_projects["project1"].description == "Development project for the engineering team"
    error_message = "Project description did not match expected value"
  }

  assert {
    condition     = module.dev_center_projects["project1"].maximum_dev_boxes_per_user == 3
    error_message = "Project maximum dev boxes per user did not match expected value"
  }
}
