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

  dev_center_catalogs = {
    integration_catalog = {
      name = "integration-test-catalog"
      dev_center = {
        key = "devcenter1"
      }
      github = {
        uri    = "https://github.com/microsoft/devcenter-catalog"
        branch = "main"
        path   = "/Environments"
      }
      tags = {
        environment = "test"
        module      = "dev_center_catalog"
        test_type   = "integration"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_project_environment_types = {}
  dev_center_network_connections       = {}
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

run "full_infrastructure_creation" {
  command = plan

  module {
    source = "../../"
  }

  // Test that resources exist
  assert {
    condition     = module.resource_groups["rg1"] != null
    error_message = "Resource group should exist"
  }

  assert {
    condition     = module.dev_centers["devcenter1"] != null
    error_message = "Dev center should exist"
  }

  assert {
    condition     = module.dev_center_projects["project1"] != null
    error_message = "Project should exist"
  }

  assert {
    condition     = module.dev_center_environment_types["envtype1"] != null
    error_message = "Environment type should exist"
  }

  assert {
    condition     = module.dev_center_catalogs["integration_catalog"] != null
    error_message = "Dev center catalog should exist"
  }

  // Test input variable values
  assert {
    condition     = var.resource_groups.rg1.name == "test-resource-group"
    error_message = "Resource group name in variables should match expected value"
  }

  assert {
    condition     = var.dev_centers.devcenter1.identity.type == "SystemAssigned"
    error_message = "Dev center identity type should be SystemAssigned"
  }

  assert {
    condition     = var.dev_center_projects.project1.maximum_dev_boxes_per_user == 3
    error_message = "Project max dev boxes should be 3"
  }
}
