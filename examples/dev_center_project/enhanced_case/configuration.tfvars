global_settings = {
  prefixes      = ["prod"]
  random_length = 5
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "production"
    project     = "devfactory"
    cost_center = "engineering"
  }
}

resource_groups = {
  rg1 = {
    name   = "devfactory-enhanced"
    region = "eastus2"
  }
}

dev_centers = {
  devcenter1 = {
    name = "devc" # Use shorter name to prevent length issues
    resource_group = {
      key = "rg1"
    }
    identity = {
      type = "SystemAssigned"
    }
    tags = {
      tier = "premium"
    }
  }
}

dev_center_projects = {
  ai_project = {
    name = "ai-development"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "AI/ML development project with full feature set"
    display_name               = "AI Development Project"
    maximum_dev_boxes_per_user = 5

    # System-assigned managed identity for secure operations
    identity = {
      type = "SystemAssigned"
    }

    # Enable Azure AI services for development workflows
    azure_ai_services_settings = {
      azure_ai_services_mode = "AutoDeploy"
    }

    # Sync both environment and image definitions from catalogs
    catalog_settings = {
      catalog_item_sync_types = ["EnvironmentDefinition", "ImageDefinition"]
    }

    # Enable user customizations for personalized development environments
    customization_settings = {
      user_customizations_enable_status = "Enabled"
      identities                        = [] # Could include user-assigned identities for customization
    }

    # Auto-delete inactive Dev Boxes for cost optimization
    dev_box_auto_delete_settings = {
      delete_mode        = "Auto"
      grace_period       = "PT24H" # 24 hours grace period before deletion
      inactive_threshold = "PT72H" # Mark for deletion after 72 hours of inactivity
    }

    # Serverless GPU sessions for AI/ML workloads
    serverless_gpu_sessions_settings = {
      max_concurrent_sessions_per_project = 10
      serverless_gpu_sessions_mode        = "AutoDeploy"
    }

    # Auto-deploy workspace storage for seamless development
    workspace_storage_settings = {
      workspace_storage_mode = "AutoDeploy"
    }

    tags = {
      module      = "dev_center_project"
      workload    = "ai-ml"
      tier        = "premium"
      auto_delete = "enabled"
    }
  }

  web_project = {
    name = "web-development"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "Web development project with standard configuration"
    display_name               = "Web Development Project"
    maximum_dev_boxes_per_user = 3

    # Basic configuration - no AI services or GPU needed
    azure_ai_services_settings = {
      azure_ai_services_mode = "Disabled"
    }

    catalog_settings = {
      catalog_item_sync_types = ["EnvironmentDefinition"]
    }

    customization_settings = {
      user_customizations_enable_status = "Enabled"
    }

    # Manual deletion for web development environments
    dev_box_auto_delete_settings = {
      delete_mode = "Manual"
    }

    serverless_gpu_sessions_settings = {
      serverless_gpu_sessions_mode = "Disabled"
    }

    workspace_storage_settings = {
      workspace_storage_mode = "AutoDeploy"
    }

    tags = {
      module   = "dev_center_project"
      workload = "web"
      tier     = "standard"
    }
  }
}
