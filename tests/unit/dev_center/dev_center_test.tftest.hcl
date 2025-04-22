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

run "dev_center_creation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_centers["devcenter1"].name != ""
    error_message = "Dev center name should not be empty"
  }

  assert {
    condition     = module.dev_centers["devcenter1"].location == module.resource_groups["rg1"].location
    error_message = "Dev center location did not match expected value"
  }

  assert {
    condition     = module.dev_centers["devcenter1"].resource_group_name == module.resource_groups["rg1"].name
    error_message = "Dev center resource group name did not match expected value"
  }

  assert {
    condition     = contains(keys(module.dev_centers["devcenter1"].tags), "environment")
    error_message = "Dev center tags did not contain environment tag"
  }

  assert {
    condition     = contains(keys(module.dev_centers["devcenter1"].tags), "module")
    error_message = "Dev center tags did not contain module tag"
  }
}

run "dev_center_with_system_identity" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
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
  }

  assert {
    condition     = module.dev_centers["devcenter1"].identity[0].type == "SystemAssigned"
    error_message = "Dev center identity type did not match expected value"
  }
}

run "dev_center_with_user_identity" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
    dev_centers = {
      devcenter1 = {
        name = "test-dev-center"
        resource_group = {
          key = "rg1"
        }
        identity = {
          type         = "UserAssigned"
          identity_ids = ["mock-identity-id"]
        }
        tags = {
          environment = "test"
          module      = "dev_center"
        }
      }
    }
  }

  assert {
    condition     = module.dev_centers["devcenter1"].identity[0].type == "UserAssigned"
    error_message = "Dev center identity type did not match expected value"
  }

  assert {
    condition     = module.dev_centers["devcenter1"].identity[0].identity_ids[0] == "mock-identity-id"
    error_message = "Dev center identity IDs did not match expected value"
  }
}
