global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
}

resource_groups = {
  rg1 = {
    name   = "devfactory-dc-enhanced"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name         = "devcenter-enhanced"
    display_name = "Enhanced DevCenter with 2025-04-01-preview Features"
    resource_group = {
      key = "rg1"
    }

    # Enhanced identity configuration
    identity = {
      type = "SystemAssigned"
    }

    # DevBox provisioning settings (2025-04-01-preview feature)
    dev_box_provisioning_settings = {
      install_azure_monitor_agent_enable_installation = "Disabled"
    }

    # Network settings (2025-04-01-preview feature)
    network_settings = {
      microsoft_hosted_network_enable_status = "Enabled"
    }

    # Project catalog settings (2025-04-01-preview feature)
    project_catalog_settings = {
      catalog_item_sync_enable_status = "Enabled"
    }

    tags = {
      environment = "demo"
      module      = "dev_center"
      api_version = "2025-04-01-preview"
    }
  }
}
