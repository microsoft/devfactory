global_settings = {
  prefixes      = ["contoso", "dev"]
  random_length = 5
  passthrough   = false
  use_slug      = true
  tags = {
    environment   = "development"
    project       = "devbox-platform"
    cost_center   = "engineering"
    owner         = "platform-team"
    business_unit = "product-development"
  }
}

resource_groups = {
  rg_devbox = {
    name   = "devbox-definitions"
    region = "eastus"
    tags = {
      purpose = "devbox-definitions"
      tier    = "platform"
    }
  }
}

dev_centers = {
  platform = {
    name         = "platform-devcenter"
    display_name = "Platform Development Center"
    resource_group = {
      key = "rg_devbox"
    }

    # System-assigned identity for secure operations
    identity = {
      type = "SystemAssigned"
    }

    # Enable Azure Monitor Agent for dev boxes
    dev_box_provisioning_settings = {
      install_azure_monitor_agent_enable_installation = "Enabled"
    }

    # Enable Microsoft-hosted network
    network_settings = {
      microsoft_hosted_network_enable_status = "Enabled"
    }

    # Enable catalog item synchronization
    project_catalog_settings = {
      catalog_item_sync_enable_status = "Enabled"
    }

    tags = {
      module = "dev_center"
      tier   = "platform"
    }
  }
}

dev_center_dev_box_definitions = { # Standard Windows 11 development environment
  win11_standard = {
    name = "win11-standard"
    dev_center = {
      key = "platform"
    }
    resource_group = {
      key = "rg_devbox"
    } # Standard development image (built-in Windows 11 with Visual Studio)
    image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"
    sku_name           = "general_i_8c32gb256ssd_v2"

    hibernate_support = true # Enable hibernate for cost optimization

    tags = {
      module      = "dev_center_dev_box_definition"
      image_type  = "win11"
      tier        = "standard"
      purpose     = "general-development"
      auto_delete = "enabled"
    }
  }
  # High-performance development environment for AI/ML workloads
  win11_ai_premium = {
    name = "win11-ai-premium"
    dev_center = {
      key = "platform"
    }
    resource_group = {
      key = "rg_devbox"
    } # AI/ML optimized image (using built-in Windows 11 Enterprise)
    image_reference = {
      id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"
    }
    sku_name = "general_i_32c128gb1024ssd_v2" # High-performance SKU

    hibernate_support = false # Keep running for long-running AI training

    # Test osStorageType property
    os_storage_type = "ssd_1024gb"

    tags = {
      module      = "dev_center_dev_box_definition"
      image_type  = "win11"
      tier        = "premium"
      purpose     = "ai-ml-development"
      gpu_enabled = "true"
      cost_tier   = "high"
      auto_delete = "disabled"
    }
  }
  # Specialized environment for data science work
  win11_data_science = {
    name = "win11-datascience"
    dev_center = {
      key = "platform"
    }
    resource_group = {
      key = "rg_devbox"
    } # Data science image (using built-in Windows 11 with development tools)
    image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"

    # Use simple SKU configuration
    sku_name = "general_i_16c64gb512ssd_v2"

    hibernate_support = true

    # Test osStorageType property
    os_storage_type = "ssd_512gb"

    tags = {
      module      = "dev_center_dev_box_definition"
      image_type  = "win11"
      tier        = "specialized"
      purpose     = "data-science"
      tools       = "python-r-jupyter"
      auto_delete = "enabled"
    }
  }
  # Advanced SKU object configuration example
  win11_enterprise_advanced = {
    name = "win11-enterprise-advanced"
    dev_center = {
      key = "platform"
    }
    resource_group = {
      key = "rg_devbox"
    }
    # Enterprise development image
    image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win11-m365-gen2"

    # Advanced SKU object configuration instead of simple sku_name
    sku = {
      name = "general_i_16c64gb512ssd_v2"
      tier = "Standard"
    }

    hibernate_support = true

    # Test osStorageType property
    os_storage_type = "ssd_512gb"

    tags = {
      module      = "dev_center_dev_box_definition"
      image_type  = "win11"
      tier        = "enterprise"
      purpose     = "enterprise-development"
      sku_type    = "advanced_object"
      auto_delete = "enabled"
      config_type = "advanced"
    }
  }
}
