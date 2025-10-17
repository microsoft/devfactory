variables {
  global_settings = {
    prefixes      = ["test"]
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
    development = {
      name         = "development"
      display_name = "Development Environment Type"
      dev_center = {
        key = "devcenter1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_environment_type"
        purpose     = "development"
      }
    }
    staging = {
      name = "staging"
      dev_center = {
        key = "devcenter1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_environment_type"
        purpose     = "staging"
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
      tags = {
        environment = "test"
        module      = "dev_center_project"
      }
    }
  }

  dev_center_project_environment_types = {
    // Basic project environment type
    proj_env_dev = {
      name = "development"
      project = {
        key = "project1"
      }
      environment_type = {
        key = "development"
      }
      status = "Enabled"
      tags = {
        environment = "test"
        module      = "dev_center_project_environment_type"
        purpose     = "development"
      }
    }
    // Project environment type with user role assignments
    proj_env_staging = {
      name = "staging"
      project = {
        key = "project1"
      }
      environment_type = {
        key = "staging"
      }
      status = "Enabled"
      user_role_assignments = {
        "e45e3m7c-176e-416a-b466-0c5ec8298f8a" = {
          roles = {
            "4cbf0b6c-e750-441c-98a7-10da8387e4d6" = {}
          }
        }
      }
      tags = {
        environment = "test"
        module      = "dev_center_project_environment_type"
        purpose     = "staging"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries              = {}
  dev_center_dev_box_definitions    = {}
  dev_center_network_connections    = {}
  dev_center_catalogs               = {}
  dev_center_project_pools          = {}
  dev_center_project_pool_schedules = {}
  shared_image_galleries            = {}
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

run "test_project_environment_type_creation" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_project_environment_types["proj_env_dev"] != null
    error_message = "Development project environment type module should exist"
  }

  assert {
    condition     = module.dev_center_project_environment_types["proj_env_staging"] != null
    error_message = "Staging project environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_project_environment_types)) == 2
    error_message = "Should have two project environment types (proj_env_dev and proj_env_staging)"
  }
}