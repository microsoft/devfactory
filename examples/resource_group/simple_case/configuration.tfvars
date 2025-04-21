

global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
}

resource_groups = {
  rg1 = {
    name   = "devfactory-core-unique"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "core-infrastructure"
    }
  }
  rg2 = {
    name   = "devfactory-networking-unique"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "networking"
    }
  }
  rg3 = {
    name   = "devfactory-devboxes-unique"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "development-environments"
    }
  }
}
