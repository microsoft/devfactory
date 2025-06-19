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
    name   = "devfactory-core-enhanced"
    region = "eastus"
    tags = {
      workload = "core-infrastructure"
    }
  }
  rg_dev = {
    name   = "devfactory-development-enhanced"
    region = "eastus"
    tags = {
      workload = "development-environments"
    }
  }
}

dev_centers = {
  enterprise_devcenter = {
    name = "enterprise-devcenter"
    resource_group = {
      key = "rg_core"
    }
    identity = {
      type = "SystemAssigned"
    }
    display_name = "Enterprise Development Center"
    dev_box_provisioning_settings = {
      install_azure_monitor_agent_enable_installation = "Enabled"
    }
    tags = {
      tier = "enterprise"
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

  premium_dev = {
    name = "premium-developer-vm"
    dev_center = {
      key = "enterprise_devcenter"
    }
    display_name = "Premium Developer Machine"
    image_reference = {
      id = "/subscriptions/12345678-1234-5678-9012-123456789012/resourceGroups/rg-images/providers/Microsoft.Compute/galleries/enterpriseGallery/images/vs2022-enterprise-premium/versions/latest"
    }
    sku = {
      name = "general_i_16c64gb512ssd_v2"
    }
    os_storage_type   = "ssd_1024gb"
    hibernate_support = "Enabled"
  }
}

dev_center_projects = {
  frontend_team = {
    name = "frontend-development"
    dev_center = {
      key = "enterprise_devcenter"
    }
    resource_group = {
      key = "rg_dev"
    }
    display_name               = "Frontend Development Team"
    description                = "Development environment for frontend team with multiple pool configurations"
    maximum_dev_boxes_per_user = 3

    tags = {
      team = "frontend"
      tier = "premium"
    }
  }

  backend_team = {
    name = "backend-development"
    dev_center = {
      key = "enterprise_devcenter"
    }
    resource_group = {
      key = "rg_dev"
    }
    display_name               = "Backend Development Team"
    description                = "Development environment for backend team"
    maximum_dev_boxes_per_user = 2

    tags = {
      team = "backend"
      tier = "standard"
    }
  }
}

dev_center_project_pools = {
  frontend_standard = {
    name = "frontend-standard-pool"
    dev_center_project = {
      key = "frontend_team"
    }
    dev_box_definition_name                 = "standard-developer-vm"
    display_name                            = "Frontend Standard Development Pool"
    local_administrator_enabled             = true
    network_connection_name                 = "default"
    stop_on_disconnect_grace_period_minutes = 90
    license_type                            = "Windows_Client"
    virtual_network_type                    = "Managed"
    single_sign_on_status                   = "Enabled"

    tags = {
      module = "dev_center_project_pool"
      tier   = "standard"
      team   = "frontend"
    }
  }

  frontend_premium = {
    name = "frontend-premium-pool"
    dev_center_project = {
      key = "frontend_team"
    }
    dev_box_definition_name                 = "premium-developer-vm"
    display_name                            = "Frontend Premium Development Pool"
    local_administrator_enabled             = true
    network_connection_name                 = "default"
    stop_on_disconnect_grace_period_minutes = 120
    license_type                            = "Windows_Client"
    virtual_network_type                    = "Managed"
    single_sign_on_status                   = "Enabled"

    tags = {
      module = "dev_center_project_pool"
      tier   = "premium"
      team   = "frontend"
    }
  }

  backend_standard = {
    name = "backend-development-pool"
    dev_center_project = {
      key = "backend_team"
    }
    dev_box_definition_name                 = "standard-developer-vm"
    display_name                            = "Backend Development Pool"
    local_administrator_enabled             = false
    network_connection_name                 = "default"
    stop_on_disconnect_grace_period_minutes = 60
    license_type                            = "Windows_Client"
    virtual_network_type                    = "Managed"
    single_sign_on_status                   = "Disabled"

    tags = {
      module = "dev_center_project_pool"
      tier   = "standard"
      team   = "backend"
    }
  }
}
