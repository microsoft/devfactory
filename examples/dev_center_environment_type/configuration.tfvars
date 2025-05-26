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

dev_center_environment_types = {
  envtype1 = {
    name         = "terraform-env"
    display_name = "Terraform Environment Type"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_environment_type"
    }
  }
}
