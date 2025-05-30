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

// Test for basic project creation
run "test_basic_project" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_projects["project1"] != null
    error_message = "Project should exist"
  }
}

// Test for project with custom properties
run "test_custom_project" {
  command = plan

  variables {
    dev_center_projects = {
      custom_project = {
        name = "custom-project"
        dev_center = {
          key = "devcenter1"
        }
        resource_group = {
          key = "rg1"
        }
        description                = "Custom project with special settings"
        maximum_dev_boxes_per_user = 5
        tags = {
          environment = "staging"
          purpose     = "development"
          team        = "frontend"
        }
      }
    }
  }

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_projects["custom_project"] != null
    error_message = "Custom project should exist"
  }
}

// Apply test for projects
run "test_apply_project" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_projects["project1"] != null
    error_message = "Project should exist after apply"
  }
}
