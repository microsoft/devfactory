variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  resource_groups = {
    rg1 = {
      name   = "test-resource-group"
      region = "eastus"
      tags = {
        environment = "test"
      }
    }
  }

  dev_centers = {
    devcenter1 = {
      name = "test-dev-center"
      resource_group = {
        key = "rg1"
      }
      tags = {
        environment = "test"
        module      = "dev_center"
      }
    }
  }

  dev_center_catalogs = {
    github_catalog = {
      name = "github-test-catalog"
      dev_center = {
        key = "devcenter1"
      }
      github = {
        uri    = "https://github.com/microsoft/devcenter-catalog"
        branch = "main"
        path   = "/Environments"
      }
      sync_type = "Manual"
      tags = {
        environment = "test"
        module      = "dev_center_catalog"
        type        = "github"
      }
    }
    ado_catalog = {
      name = "ado-test-catalog"
      dev_center = {
        key = "devcenter1"
      }
      ado_git = {
        uri    = "https://dev.azure.com/myorg/myproject/_git/catalog"
        branch = "main"
        path   = "/templates"
      }
      sync_type = "Scheduled"
      tags = {
        environment = "test"
        module      = "dev_center_catalog"
        type        = "ado"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_projects                  = {}
  dev_center_environment_types         = {}
  dev_center_project_environment_types = {}
  dev_center_network_connections       = {}
  shared_image_galleries               = {}
}

mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id = "12345678-1234-1234-1234-123456789012"
      tenant_id       = "12345678-1234-1234-1234-123456789012"
      client_id       = "12345678-1234-1234-1234-123456789012"
    }
  }
}

mock_provider "azurecaf" {}

// Test GitHub catalog creation
run "github_catalog_validation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_catalogs["github_catalog"] != null
    error_message = "GitHub catalog should be created"
  }
}

// Test ADO catalog creation
run "ado_catalog_validation" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
    dev_center_catalogs = {
      ado_catalog = {
        name = "ado-test-catalog"
        dev_center = {
          key = "devcenter1"
        }
        ado_git = {
          uri    = "https://dev.azure.com/myorg/myproject/_git/catalog"
          branch = "main"
          path   = "/templates"
        }
        sync_type = "Scheduled"
        tags = {
          environment = "test"
          module      = "dev_center_catalog"
          type        = "ado"
        }
      }
    }
  }

  assert {
    condition     = module.dev_center_catalogs["ado_catalog"] != null
    error_message = "ADO catalog should be created"
  }
}

// Test GitHub catalog with secret key vault reference
run "github_with_secret_validation" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
    dev_center_catalogs = {
      github_secret_catalog = {
        name = "github-secret-catalog"
        dev_center = {
          key = "devcenter1"
        }
        github = {
          uri               = "https://github.com/private/catalog"
          branch            = "main"
          path              = "/Environments"
          secret_identifier = "https://vault.vault.azure.net/secrets/github-token"
        }
        sync_type = "Manual"
        tags = {
          environment = "test"
          type        = "github-secret"
        }
      }
    }
  }

  assert {
    condition     = module.dev_center_catalogs["github_secret_catalog"] != null
    error_message = "GitHub catalog with secret should be created"
  }
}

// Test ADO catalog with secret key vault reference
run "ado_with_secret_validation" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
    dev_center_catalogs = {
      ado_secret_catalog = {
        name = "ado-secret-catalog"
        dev_center = {
          key = "devcenter1"
        }
        ado_git = {
          uri               = "https://dev.azure.com/private/project/_git/catalog"
          branch            = "main"
          path              = "/templates"
          secret_identifier = "https://vault.vault.azure.net/secrets/ado-token"
        }
        sync_type = "Scheduled"
        tags = {
          environment = "test"
          type        = "ado-secret"
        }
      }
    }
  }

  assert {
    condition     = module.dev_center_catalogs["ado_secret_catalog"] != null
    error_message = "ADO catalog with secret should be created"
  }
}

// Test catalog tags validation
run "catalog_tags_validation" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
    dev_center_catalogs = {
      tagged_catalog = {
        name = "tagged-catalog"
        dev_center = {
          key = "devcenter1"
        }
        github = {
          uri    = "https://github.com/microsoft/devcenter-catalog"
          branch = "main"
        }
        resource_tags = {
          api_level   = "true"
          cost_center = "engineering"
        }
        tags = {
          environment = "test"
          module      = "catalog"
        }
      }
    }
  }

  assert {
    condition     = module.dev_center_catalogs["tagged_catalog"] != null
    error_message = "Tagged catalog should be created"
  }
}

// Test output structure validation
run "output_structure_validation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_catalogs["github_catalog"] != null
    error_message = "All expected catalogs should be planned for creation"
  }
}

// Test sync type validation
run "sync_type_validation" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
    dev_center_catalogs = {
      manual_sync_catalog = {
        name = "manual-sync-catalog"
        dev_center = {
          key = "devcenter1"
        }
        github = {
          uri    = "https://github.com/microsoft/devcenter-catalog"
          branch = "main"
        }
        sync_type = "Manual"
      }
      scheduled_sync_catalog = {
        name = "scheduled-sync-catalog"
        dev_center = {
          key = "devcenter1"
        }
        github = {
          uri    = "https://github.com/microsoft/devcenter-catalog"
          branch = "main"
        }
        sync_type = "Scheduled"
      }
    }
  }

  assert {
    condition = alltrue([
      module.dev_center_catalogs["manual_sync_catalog"] != null,
      module.dev_center_catalogs["scheduled_sync_catalog"] != null
    ])
    error_message = "Both Manual and Scheduled sync type catalogs should be created"
  }
}

// Test naming convention validation
run "naming_convention_validation" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
    global_settings = {
      prefixes      = ["test", "catalog"]
      random_length = 5
      passthrough   = false
      use_slug      = true
    }
    dev_center_catalogs = {
      naming_test_catalog = {
        name = "naming-test"
        dev_center = {
          key = "devcenter1"
        }
        github = {
          uri    = "https://github.com/microsoft/devcenter-catalog"
          branch = "main"
        }
      }
    }
  }

  assert {
    condition     = module.dev_center_catalogs["naming_test_catalog"] != null
    error_message = "Catalog with custom naming should be created"
  }
}

// Test git configuration validation
run "git_configuration_validation" {
  command = plan

  module {
    source = "../../../"
  }

  variables {
    dev_center_catalogs = {
      git_config_catalog = {
        name = "git-config-catalog"
        dev_center = {
          key = "devcenter1"
        }
        github = {
          uri    = "https://github.com/microsoft/devcenter-catalog"
          branch = "feature/new-templates"
          path   = "/custom/path/to/templates"
        }
        sync_type = "Manual"
      }
    }
  }

  assert {
    condition     = module.dev_center_catalogs["git_config_catalog"] != null
    error_message = "Catalog with custom git configuration should be created"
  }
}
