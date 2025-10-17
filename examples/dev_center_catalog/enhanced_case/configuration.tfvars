global_settings = {
  prefixes      = ["contoso", "platform"]
  random_length = 5
  passthrough   = false
  use_slug      = true
  tags = {
    environment   = "production"
    project       = "devcenter-platform"
    cost_center   = "IT"
    owner         = "platform-team"
    business_unit = "engineering"
  }
}

resource_groups = {
  rg_devcenter_prod = {
    name   = "devcenter-prod"
    region = "eastus"
    tags = {
      purpose = "production"
      tier    = "platform"
    }
  }
}

dev_centers = {
  production = {
    name         = "production-devcenter"
    display_name = "Production Development Center"
    resource_group = {
      key = "rg_devcenter_prod"
    }

    # Enable Azure Monitor Agent for dev boxes
    dev_box_provisioning_settings = {
      install_azure_monitor_agent_enable_installation = "Enabled"
    }

    # Enable Microsoft-hosted network
    network_settings = {
      microsoft_hosted_network_enable_status = "Enabled"
    }

    # Enable catalog item sync for projects
    project_catalog_settings = {
      catalog_item_sync_enable_status = "Enabled"
    }

    tags = {
      tier       = "production"
      support    = "24x7"
      compliance = "required"
    }
  }
}

dev_center_catalogs = {
  # Official Microsoft catalog for environment definitions
  microsoft_environments = {
    name      = "microsoft-environments"
    sync_type = "Scheduled"
    dev_center = {
      key = "production"
    }

    github = {
      branch = "main"
      uri    = "https://github.com/microsoft/devcenter-catalog.git"
      path   = "Environment-Definitions"
    }

    resource_tags = {
      catalog_type    = "environment-definitions"
      source          = "microsoft-official"
      update_schedule = "daily"
    }

    tags = {
      purpose   = "environment-templates"
      source    = "microsoft"
      sync_mode = "scheduled"
    }
  }

  # Company-specific environment definitions
  company_environments = {
    name      = "company-environments"
    sync_type = "Scheduled"
    dev_center = {
      key = "production"
    }

    github = {
      branch = "main"
      uri    = "https://github.com/contoso/devcenter-environments.git"
      path   = "environments"
      # In production, this would point to a Key Vault secret containing a PAT
      # secret_identifier = "https://kv-contoso-prod.vault.azure.net/secrets/github-pat"
    }

    resource_tags = {
      catalog_type    = "environment-definitions"
      source          = "company-custom"
      update_schedule = "daily"
      compliance      = "sox-compliant"
    }

    tags = {
      purpose       = "custom-environments"
      source        = "internal"
      sync_mode     = "scheduled"
      security_tier = "high"
    }
  }

  # Azure DevOps catalog for dev box definitions
  devbox_definitions = {
    name      = "devbox-definitions"
    sync_type = "Manual"
    dev_center = {
      key = "production"
    }

    ado_git = {
      branch = "release"
      uri    = "https://dev.azure.com/contoso/Platform/_git/DevBoxDefinitions"
      path   = "definitions"
      # In production, this would point to a Key Vault secret containing a PAT
      # secret_identifier = "https://kv-contoso-prod.vault.azure.net/secrets/ado-pat"
    }

    resource_tags = {
      catalog_type    = "devbox-definitions"
      source          = "azure-devops"
      update_schedule = "manual"
      review_required = "true"
    }

    tags = {
      purpose       = "dev-box-templates"
      source        = "azure-devops"
      sync_mode     = "manual"
      security_tier = "medium"
    }
  }

  # Third-party catalog for specialized tools
  third_party_tools = {
    name      = "third-party-tools"
    sync_type = "Manual"
    dev_center = {
      key = "production"
    }

    github = {
      branch = "stable"
      uri    = "https://github.com/contoso-partners/specialized-tools.git"
      path   = "catalog"
      # In production, this would point to a Key Vault secret containing a PAT
      # secret_identifier = "https://kv-contoso-prod.vault.azure.net/secrets/partner-github-pat"
    }

    resource_tags = {
      catalog_type    = "specialized-tools"
      source          = "third-party"
      update_schedule = "manual"
      review_required = "true"
      vendor          = "contoso-partners"
    }

    tags = {
      purpose       = "specialized-tools"
      source        = "external"
      sync_mode     = "manual"
      security_tier = "high"
      vendor        = "partner"
    }
  }
}
