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
      name = "test-definition"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      image_reference = {
        id = "/subscriptions/12345678-1234-5678-9012-123456789012/resourceGroups/rg-images/providers/Microsoft.Compute/galleries/myGallery/images/myImage/versions/1.0.0"
      }
      sku = {
        name = "general_i_8c32gb256ssd_v2"
      }
      os_storage_type = "ssd_1024gb"
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

  dev_center_project_pools = {
    pool1 = {
      name = "test-pool"
      dev_center_project = {
        key = "project1"
      }
      resource_group = {
        key = "rg1"
      }
      dev_box_definition_name                 = "definition1"
      display_name                            = "Test Pool"
      local_administrator_enabled             = false
      network_connection_name                 = "default"
      stop_on_disconnect_grace_period_minutes = 60
      license_type                            = "Windows_Client"
      virtual_network_type                    = "Managed"
      single_sign_on_status                   = "Disabled"

      tags = {
        environment = "test"
        module      = "dev_center_project_pool"
      }
    }
  }

  dev_center_project_pool_schedules = {
    schedule1 = {
      dev_center_project_pool = {
        key = "pool1"
      }
      schedule = {
        name      = "test-schedule"
        type      = "StopDevBox"
        frequency = "Daily"
        time      = "18:00"
        time_zone = "W. Europe Standard Time"
        state     = "Enabled"
        tags = {
          environment = "test"
          module      = "dev_center_project_pool_schedule"
        }
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
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

// Test for basic schedule creation
run "test_basic_schedule" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_project_pool_schedules["schedule1"] != null
    error_message = "Schedule should exist"
  }
}

// Test for schedule with custom properties
run "test_custom_schedule" {
  command = plan

  variables {
    dev_center_project_pool_schedules = {
      custom_schedule = {
        dev_center_project_pool = {
          key = "pool1"
        }
        schedule = {
          name      = "custom-schedule"
          type      = "StartDevBox"
          frequency = "Weekly"
          time      = "08:30"
          time_zone = "Eastern Standard Time"
          state     = "Disabled"
          tags = {
            environment = "test"
            module      = "dev_center_project_pool_schedule"
            custom      = "yes"
          }
        }
      }
    }
  }

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_project_pool_schedules["custom_schedule"] != null
    error_message = "Custom schedule should exist"
  }
}

// Test multiple schedules for the same pool
run "test_multiple_schedules" {
  command = plan

  variables {
    dev_center_project_pool_schedules = {
      morning_start = {
        dev_center_project_pool = {
          key = "pool1"
        }
        schedule = {
          name      = "morning-start"
          type      = "StartDevBox"
          frequency = "Daily"
          time      = "08:00"
          time_zone = "W. Europe Standard Time"
          state     = "Enabled"
        }
      }
      evening_stop = {
        dev_center_project_pool = {
          key = "pool1"
        }
        schedule = {
          name      = "evening-stop"
          type      = "StopDevBox"
          frequency = "Daily"
          time      = "18:00"
          time_zone = "W. Europe Standard Time"
          state     = "Enabled"
        }
      }
    }
  }

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_project_pool_schedules["morning_start"] != null
    error_message = "Morning start schedule should exist"
  }

  assert {
    condition     = module.dev_center_project_pool_schedules["evening_stop"] != null
    error_message = "Evening stop schedule should exist"
  }
}
