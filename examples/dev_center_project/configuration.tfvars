global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "demo"
    project     = "devfactory"
  }
}

resource_groups = {
  rg1 = {
    name   = "devfactory-dc"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name = "devcenter"
    resource_group = {
      key = "rg1"
    }
    identity = {
      type = "SystemAssigned"
    }
    tags = {
      environment = "demo"
    }
  }
}

dev_center_projects = {
  project1 = {
    name = "devproject"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "Development project for the engineering team"
    display_name               = "Engineering Development Project"
    maximum_dev_boxes_per_user = 3

    # Identity configuration
    identity = {
      type = "SystemAssigned"
    }

    # Azure AI Services configuration
    azure_ai_services_settings = {
      azure_ai_services_mode = "Disabled"
    }

    # Catalog synchronization settings
    catalog_settings = {
      catalog_item_sync_types = ["EnvironmentDefinition", "ImageDefinition"]
    }

    # User customization settings
    customization_settings = {
      user_customizations_enable_status = "Enabled"
      identities                        = []
    }

    # Auto-delete configuration for cost management
    dev_box_auto_delete_settings = {
      delete_mode        = "Auto"
      grace_period       = "PT24H" # 24 hours grace period
      inactive_threshold = "PT72H" # Delete after 72 hours of inactivity
    }

    # Serverless GPU sessions for AI workloads
    serverless_gpu_sessions_settings = {
      max_concurrent_sessions_per_project = 5
      serverless_gpu_sessions_mode        = "Disabled"
    }

    # Workspace storage settings
    workspace_storage_settings = {
      workspace_storage_mode = "AutoDeploy"
    }

    tags = {
      environment = "demo"
      module      = "dev_center_project"
      cost_center = "engineering"
    }
  }
}
