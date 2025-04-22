variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  resource_groups = {
    rg1 = {
      name   = "devfactory-dc"
      region = "eastus"
    }
  }

  dev_centers = {
    devcenter1 = {
      name = "devcenter"
      resource_group = {
        key = "rg1"
      }
      identity = {
        type = "SystemAssigned"
      }
      tags = {
        environment = "demo"
        module      = "dev_center"
      }
    }
  }

  // Empty variables required by the root module
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

run "system_assigned_identity_example" {
  command = plan

  module {
    source = "../../"
  }

  // Use the tfvars file from the example
  variables {
    file = "../../examples/dev_center/system_assigned_identity/configuration.tfvars"
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

  // Test dev center identity
  assert {
    condition     = module.dev_centers["devcenter1"].identity[0].type == "SystemAssigned"
    error_message = "Dev center identity type did not match expected value"
  }
}
