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

  dev_center_environment_types = {
    envtype1 = {
      name         = "test-environment-type"
      display_name = "Test Environment Type Display Name"
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
  dev_center_projects                  = {}
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

// Test for basic environment type
run "test_basic_environment_type" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_environment_types["envtype1"] != null
    error_message = "Environment type should exist"
  }
}

// Test for environment type with custom configuration
run "test_custom_environment_type" {
  command = plan

  variables {
    dev_center_environment_types = {
      custom_env = {
        name         = "custom-environment-type"
        display_name = "Custom Environment Type"
        dev_center = {
          key = "devcenter1"
        }
        tags = {
          environment = "staging"
          purpose     = "testing"
          owner       = "dev-team"
        }
      }
    }
  }

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_environment_types["custom_env"] != null
    error_message = "Custom environment type should exist"
  }
}

// Apply test for environment types
run "test_apply_environment_type" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_environment_types["envtype1"] != null
    error_message = "Environment type should exist after apply"
  }
}
