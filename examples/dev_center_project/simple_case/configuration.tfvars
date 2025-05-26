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
    name   = "devfactory-simple"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name = "simple-devcenter"
    resource_group = {
      key = "rg1"
    }
    identity = {
      type = "SystemAssigned"
    }
  }
}

dev_center_projects = {
  project1 = {
    name = "simple-project"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "Simple development project"
    maximum_dev_boxes_per_user = 2

    tags = {
      module = "dev_center_project"
      tier   = "basic"
    }
  }
}
