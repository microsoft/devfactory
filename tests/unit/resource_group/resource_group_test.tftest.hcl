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

mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id = "12345678-1234-1234-1234-123456789012"
      tenant_id       = "12345678-1234-1234-1234-123456789012"
      client_id       = "12345678-1234-1234-1234-123456789012"
    }
  }
}

mock_provider "azurecaf" {}

// Test for basic resource group creation
run "test_basic_resource_group" {
  command = plan

  variables {
    resource_groups = {
      rg1 = {
        name   = "test-basic-resource-group"
        region = "eastus"
        tags = {
          environment = "test"
        }
      }
    }
  }

  module {
    source = "../../../"
  }

  assert {
    condition     = module.resource_groups["rg1"] != null
    error_message = "Resource group should exist"
  }

  assert {
    condition     = module.resource_groups["rg1"].location == "eastus"
    error_message = "Resource group location did not match expected value"
  }
}

// Test for resource group with custom tags
run "test_resource_group_with_custom_tags" {
  command = plan

  variables {
    resource_groups = {
      rg2 = {
        name   = "test-tagged-resource-group"
        region = "westus"
        tags = {
          environment = "production"
          owner       = "platform-team"
          costcenter  = "12345"
        }
      }
    }
  }

  module {
    source = "../../../"
  }

  assert {
    condition     = module.resource_groups["rg2"] != null
    error_message = "Resource group with custom tags should exist"
  }

  assert {
    condition     = module.resource_groups["rg2"].location == "westus"
    error_message = "Resource group location did not match expected value"
  }
}

// Apply test for resource groups
run "test_apply_resource_groups" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.resource_groups["rg1"] != null
    error_message = "Resource group should exist after apply"
  }
}
