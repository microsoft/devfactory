// filepath: /Users/arnaud/Documents/github/arnaudlh/devfactory/examples/dev_center/system_assigned_identity/configuration.tfvars
global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "development"
    owner       = "DevOps Team"
  }
}

resource_groups = {
  rg1 = {
    name   = "devfactory-systemid-demo"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "devcenter-system-identity-example"
    }
  }
}

dev_centers = {
  devcenter1 = {
    name = "systemid-demo"
    resource_group = {
      key = "rg1"
    }
    region = "eastus"

    # System assigned identity configuration
    identity = {
      type = "SystemAssigned"
    }

    tags = {
      purpose = "system-identity-example"
    }
  }
}
