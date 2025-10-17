global_settings = {
  prefixes      = ["contoso"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "dev"
    project     = "platform"
  }
}

resource_groups = {
  rg_dev_center = {
    name   = "dev-center"
    region = "eastus"
    tags = {
      purpose = "development"
    }
  }
}

dev_centers = {
  main = {
    name         = "main-dev-center"
    display_name = "Main Development Center"
    resource_group = {
      key = "rg_dev_center"
    }
    tags = {
      team = "platform"
    }
  }
}

dev_center_catalogs = {
  github_catalog = {
    name      = "github-templates"
    sync_type = "Scheduled"
    dev_center = {
      key = "main"
    }

    github = {
      branch = "main"
      uri    = "https://github.com/microsoft/devcenter-catalog.git"
      path   = "Environment-Definitions"
    }

    tags = {
      catalog_type = "github"
      purpose      = "templates"
    }
  }

  ado_catalog = {
    name      = "ado-definitions"
    sync_type = "Manual"
    dev_center = {
      key = "main"
    }

    ado_git = {
      branch = "develop"
      uri    = "https://dev.azure.com/contoso/Platform/_git/DevBoxDefinitions"
      path   = "definitions"
    }

    tags = {
      catalog_type = "ado"
      team         = "infrastructure"
    }
  }
}
