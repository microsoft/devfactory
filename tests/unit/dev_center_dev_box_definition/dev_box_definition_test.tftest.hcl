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

  dev_center_dev_box_definitions = {
    definition1 = {
      name = "test-dev-box-definition"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      image_reference_id = try(var.dev_box_definition.image_reference_id, null)
      sku_name           = try(var.dev_box_definition.sku_name, null)
      tags = {
        environment = "test"
        module      = "dev_center_dev_box_definition"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_projects                  = {}
  dev_center_environment_types         = {}
  dev_center_project_environment_types = {}
  dev_center_network_connections       = {}
  dev_center_catalogs                  = {}
  shared_image_galleries               = {}
}

mock_provider "azurerm" {}

run "dev_box_definition_creation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_dev_box_definitions["definition1"].name != ""
    error_message = "Dev Box Definition name should not be empty"
  }

  assert {
    condition     = contains(keys(module.dev_center_dev_box_definitions["definition1"]), "id")
    error_message = "Dev Box Definition ID should be present in module outputs"
  }

  assert {
    condition     = contains(keys(module.dev_center_dev_box_definitions["definition1"].tags), "environment")
    error_message = "Dev Box Definition tags did not contain environment tag"
  }

  assert {
    condition     = contains(keys(module.dev_center_dev_box_definitions["definition1"].tags), "module")
    error_message = "Dev Box Definition tags did not contain module tag"
  }
}
