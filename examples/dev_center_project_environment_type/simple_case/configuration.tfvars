global_settings = {
  prefixes      = ["demo"]
  random_length = 3
  passthrough   = false
  use_slug      = true
}

resource_groups = {
  rg1 = {
    name   = "devcenter-demo"
    region = "eastus"
    tags = {
      environment = "demo"
      purpose     = "dev-center-testing"
    }
  }
}

dev_centers = {
  devcenter1 = {
    name = "demo-devcenter"
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center"
    }
  }
}

dev_center_environment_types = {
  development = {
    name = "development"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "demo"
      purpose     = "development"
    }
  }
  staging = {
    name = "staging"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "demo"
      purpose     = "staging"
    }
  }
}

dev_center_projects = {
  project1 = {
    name = "demo-project"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_project"
    }
  }
}

dev_center_project_environment_types = {
  proj_env_dev = {
    name = "development"
    project = {
      key = "project1"
    }
    environment_type = {
      key = "development"
    }
    status = "Enabled"
    tags = {
      environment = "demo"
      purpose     = "project-environment-association"
    }
  }
  proj_env_staging = {
    name = "staging"
    project = {
      key = "project1"
    }
    environment_type = {
      key = "staging"
    }
    status = "Enabled"
    tags = {
      environment = "demo"
      purpose     = "project-environment-association"
    }
  }
}

# Empty variables required by the root module
dev_center_galleries              = {}
dev_center_dev_box_definitions    = {}
dev_center_network_connections    = {}
dev_center_catalogs               = {}
dev_center_project_pools          = {}
dev_center_project_pool_schedules = {}
shared_image_galleries            = {}