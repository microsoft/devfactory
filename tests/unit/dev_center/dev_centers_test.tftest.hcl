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

  // Test with different identity types
  dev_centers = {
    // Default with no identity specified
    basic_center = {
      name = "test-dev-center-basic"
      resource_group = {
        key = "rg1"
      }
      tags = {
        environment = "test"
        module      = "dev_center"
      }
    }
    // With system-assigned identity
    system_identity = {
      name = "test-dev-center-system"
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
    // With user-assigned identity
    user_identity = {
      name = "test-dev-center-user"
      resource_group = {
        key = "rg1"
      }
      identity = {
        type         = "UserAssigned"
        identity_ids = ["/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-identity"]
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

// Test for basic Dev Center (no identity)
run "test_basic_dev_center" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with only the basic center
    dev_centers = {
      basic_center = {
        name = "test-dev-center-basic"
        resource_group = {
          key = "rg1"
        }
        tags = {
          environment = "test"
          module      = "dev_center"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_centers["basic_center"] != null
    error_message = "Basic dev center module should exist"
  }

  assert {
    condition     = length(keys(module.dev_centers)) == 1
    error_message = "Should only have one dev center (basic)"
  }
}

// Test for System-Assigned Identity Dev Center
run "test_system_identity_dev_center" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with only the system identity center
    dev_centers = {
      system_identity = {
        name = "test-dev-center-system"
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

  module { source = "../../../" }

  assert {
    condition     = module.dev_centers["system_identity"] != null
    error_message = "System identity dev center module should exist"
  }

  assert {
    condition     = length(keys(module.dev_centers)) == 1
    error_message = "Should only have one dev center (system identity)"
  }

  // For mocked resources, we can only check that the module exists
  assert {
    condition     = module.dev_centers["system_identity"] != null
    error_message = "System identity dev center module should exist"
  }
}

// Test for User-Assigned Identity Dev Center
run "test_user_identity_dev_center" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with only the user identity center
    dev_centers = {
      user_identity = {
        name = "test-dev-center-user"
        resource_group = {
          key = "rg1"
        }
        identity = {
          type         = "UserAssigned"
          identity_ids = ["/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-identity"]
        }
        tags = {
          environment = "test"
          module      = "dev_center"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_centers["user_identity"] != null
    error_message = "User identity dev center module should exist"
  }

  assert {
    condition     = length(keys(module.dev_centers)) == 1
    error_message = "Should only have one dev center (user identity)"
  }

  // For mocked resources, we can only check that the module exists
  assert {
    condition     = module.dev_centers["user_identity"] != null
    error_message = "User identity dev center module should exist"
  }
}

// Integration test that applies all types of dev centers
run "test_all_identity_types_apply" {
  command = apply

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_centers["basic_center"] != null
    error_message = "Basic dev center module should exist"
  }

  assert {
    condition     = module.dev_centers["system_identity"] != null
    error_message = "System identity dev center module should exist"
  }

  assert {
    condition     = module.dev_centers["user_identity"] != null
    error_message = "User identity dev center module should exist"
  }

  assert {
    condition     = length(keys(module.dev_centers)) == 3
    error_message = "Should have all three dev centers"
  }
}