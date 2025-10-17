global_settings = {
  prefixes      = ["prod"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  tags = {
    company     = "contoso"
    cost_center = "engineering"
  }
}

resource_groups = {
  rg1 = {
    name   = "devcenter-prod"
    region = "eastus"
    tags = {
      environment = "production"
      purpose     = "dev-center-production"
    }
  }
}

dev_centers = {
  devcenter1 = {
    name = "prod-devcenter"
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "production"
      module      = "dev_center"
    }
  }
}

dev_center_environment_types = {
  development = {
    name         = "development"
    display_name = "Development Environment"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "production"
      purpose     = "development"
    }
  }
  staging = {
    name         = "staging"
    display_name = "Staging Environment"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "production"
      purpose     = "staging"
    }
  }
  production = {
    name         = "production"
    display_name = "Production Environment"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "production"
      purpose     = "production"
    }
  }
}

dev_center_projects = {
  project1 = {
    name = "prod-project"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "production"
      module      = "dev_center_project"
      team        = "platform"
    }
  }
  project2 = {
    name = "app-project"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "production"
      module      = "dev_center_project"
      team        = "application"
    }
  }
}

dev_center_project_environment_types = {
  proj1_env_dev = {
    name = "development"
    project = {
      key = "project1"
    }
    environment_type = {
      key = "development"
    }
    status = "Enabled"
    tags = {
      environment = "production"
      purpose     = "project-environment-association"
      team        = "platform"
    }
  }
  proj1_env_staging = {
    name = "staging"
    project = {
      key = "project1"
    }
    environment_type = {
      key = "staging"
    }
    status = "Enabled"
    tags = {
      environment = "production"
      purpose     = "project-environment-association"
      team        = "platform"
    }
  }
  proj1_env_prod = {
    name = "production"
    project = {
      key = "project1"
    }
    environment_type = {
      key = "production"
    }
    status = "Enabled"
    tags = {
      environment = "production"
      purpose     = "project-environment-association"
      team        = "platform"
    }
  }
  proj2_env_dev = {
    name = "development"
    project = {
      key = "project2"
    }
    environment_type = {
      key = "development"
    }
    status = "Enabled"
    tags = {
      environment = "production"
      purpose     = "project-environment-association"
      team        = "application"
    }
  }
  proj2_env_staging = {
    name = "staging"
    project = {
      key = "project2"
    }
    environment_type = {
      key = "staging"
    }
    status = "Disabled"
    tags = {
      environment = "production"
      purpose     = "project-environment-association"
      team        = "application"
      note        = "disabled-for-maintenance"
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