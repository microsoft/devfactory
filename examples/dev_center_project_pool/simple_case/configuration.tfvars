global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "demo"
    created_by  = "terraform"
  }
}

resource_groups = {
  rg1 = {
    name   = "devfactory-pool-simple"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name = "simple-devcenter-pool"
    resource_group = {
      key = "rg1"
    }
    identity = {
      type = "SystemAssigned"
    }
  }
}

dev_center_dev_box_definitions = {
  definition1 = {
    name = "simple-definition"
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
    name = "simple-project-pool"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "Simple development project for pool testing"
    maximum_dev_boxes_per_user = 2
  }
}

dev_center_project_pools = {
  pool1 = {
    name = "development-pool"
    dev_center_project = {
      key = "project1"
    }
    resource_group = {
      key = "rg1"
    }
    dev_box_definition_name                 = "definition1"
    display_name                            = "Development Pool"
    local_administrator_enabled             = false
    network_connection_name                 = "default"
    stop_on_disconnect_grace_period_minutes = 60
    license_type                            = "Windows_Client"
    virtual_network_type                    = "Managed"
    single_sign_on_status                   = "Disabled"

    tags = {
      module = "dev_center_project_pool"
      tier   = "basic"
    }
  }
}
