global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
}

resource_groups = {
  rg1 = {
    name   = "devfactory-dc"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "devbox-example"
    }
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
      module      = "dev_center"
    }
  }
}

dev_center_dev_box_definitions = {
  definition1 = {
    name = "win11-dev"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    # Currently assumes that image definition is one of that's available in the default gallery
    # Format: /galleries/{gallery}/images/{image-definition}
    image_reference_id = "/galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc-m365"
    sku_name           = "general_i_8c32gb256ssd_v2"
    tags = {
      environment = "demo"
      module      = "dev_center_dev_box_definition"
    }
  }
}
