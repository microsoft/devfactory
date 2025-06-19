global_settings = {
  prefixes      = ["enterprise"]
  random_length = 5
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "production"
    created_by  = "terraform"
    cost_center = "engineering"
    project     = "devfactory"
  }
}

resource_groups = {
  rg_core = {
    name   = "devfactory-core-schedule"
    region = "eastus"
    tags = {
      workload = "core-infrastructure"
    }
  }
  rg_dev = {
    name   = "devfactory-development-schedule"
    region = "eastus"
    tags = {
      workload = "development-environments"
    }
  }
}

dev_centers = {
  enterprise_devcenter = {
    name = "enterprise-devcenter-schedule"
    resource_group = {
      key = "rg_core"
    }
    identity = {
      type = "SystemAssigned"
    }
    display_name = "Enterprise Development Center with Scheduling"
    dev_box_provisioning_settings = {
      install_azure_monitor_agent_enable_installation = "Enabled"
    }
  }
}

dev_center_dev_box_definitions = {
  standard_dev = {
    name = "standard-developer-vm"
    dev_center = {
      key = "enterprise_devcenter"
    }
    display_name = "Standard Developer Machine"
    image_reference = {
      id = "/subscriptions/12345678-1234-5678-9012-123456789012/resourceGroups/rg-images/providers/Microsoft.Compute/galleries/enterpriseGallery/images/vs2022-enterprise/versions/latest"
    }
    sku = {
      name = "general_i_8c32gb256ssd_v2"
    }
    os_storage_type   = "ssd_512gb"
    hibernate_support = "Enabled"
  }
}

dev_center_projects = {
  development_team = {
    name = "development-team"
    dev_center = {
      key = "enterprise_devcenter"
    }
    resource_group = {
      key = "rg_dev"
    }
    display_name               = "Development Team with Auto-Scheduling"
    description                = "Development environment with comprehensive auto-scheduling policies"
    maximum_dev_boxes_per_user = 2
  }
}

dev_center_project_pools = {
  development_pool = {
    name = "development-pool"
    dev_center_project = {
      key = "development_team"
    }
    dev_box_definition_name                 = "standard-developer-vm"
    display_name                            = "Development Pool with Scheduling"
    local_administrator_enabled             = true
    network_connection_name                 = "default"
    stop_on_disconnect_grace_period_minutes = 90
    license_type                            = "Windows_Client"
    virtual_network_type                    = "Managed"
    single_sign_on_status                   = "Enabled"
  }
}

dev_center_project_pool_schedules = {
  weekday_shutdown = {
    name = "weekday-auto-shutdown"
    dev_center_project_pool = {
      key = "development_pool"
    }
    type      = "StopDevBox"
    frequency = "Daily"
    time      = "18:00"
    time_zone = "W. Europe Standard Time"
    state     = "Enabled"

    tags = {
      module   = "dev_center_project_pool_schedule"
      schedule = "weekday-shutdown"
      policy   = "cost-optimization"
    }
  }

  morning_startup = {
    name = "morning-auto-startup"
    dev_center_project_pool = {
      key = "development_pool"
    }
    type      = "StartDevBox"
    frequency = "Daily"
    time      = "08:00"
    time_zone = "W. Europe Standard Time"
    state     = "Enabled"

    tags = {
      module   = "dev_center_project_pool_schedule"
      schedule = "morning-startup"
      policy   = "productivity-optimization"
    }
  }

  weekend_shutdown = {
    name = "weekend-extended-shutdown"
    dev_center_project_pool = {
      key = "development_pool"
    }
    type      = "StopDevBox"
    frequency = "Weekly"
    time      = "16:00"
    time_zone = "W. Europe Standard Time"
    state     = "Enabled"

    tags = {
      module   = "dev_center_project_pool_schedule"
      schedule = "weekend-shutdown"
      policy   = "weekend-cost-optimization"
    }
  }
}
