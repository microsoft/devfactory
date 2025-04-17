# DevFactory Module Guide

This document provides detailed information about each module in the DevFactory project, including their purpose, usage, and available options.

## Resource Group Module

### Purpose
Creates Azure Resource Groups with standardized naming and tagging.

### Usage
```hcl
module "resource_groups" {
  source   = "./modules/resource_group"
  for_each = var.resource_groups

  global_settings = var.global_settings
  resource_group  = each.value
  tags            = try(each.value.tags, {})
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `resource_group` | `object` | Yes | Resource group configuration object |
| `tags` | `map(string)` | No | Additional tags to apply |

### Resource Group Configuration Options
```hcl
resource_groups = {
  rg1 = {
    name   = "my-resource-group"
    region = "eastus"
    tags   = {
      environment = "development"
      workload    = "core-infrastructure"
    }
  }
}
```

## Dev Center Module

### Purpose
Creates and configures Azure Dev Center resources to support developer environments.

### Usage
```hcl
module "dev_centers" {
  source   = "./modules/dev_center"
  for_each = var.dev_centers

  global_settings     = var.global_settings
  dev_center          = each.value
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
  location            = lookup(each.value, "region", null) != null ? each.value.region : module.resource_groups[each.value.resource_group.key].location
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `dev_center` | `object` | Yes | Dev center configuration object |
| `resource_group_name` | `string` | Yes | Name of the resource group |
| `location` | `string` | Yes | Azure region for deployment |

### Dev Center Configuration Options
```hcl
dev_centers = {
  devcenter1 = {
    name = "devcenter"
    resource_group = {
      key = "rg1"
    }
    identity = {
      type = "SystemAssigned"
    }
    support_info = {
      email = "admin@contoso.com"
      url   = "https://support.contoso.com"
    }
    tags = {
      environment = "demo"
    }
  }
}
```

## Dev Center DevBox Definition Module

### Purpose
Creates DevBox definitions within an Azure Dev Center, specifying VM images, sizes, and configurations.

### Usage
```hcl
module "dev_center_dev_box_definitions" {
  source   = "./modules/dev_center_dev_box_definition"
  for_each = var.dev_center_dev_box_definitions

  global_settings     = var.global_settings
  dev_box_definition  = each.value
  dev_center_id       = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `dev_box_definition` | `object` | Yes | Dev box definition configuration object |
| `dev_center_id` | `string` | Yes | The ID of the Dev Center |
| `resource_group_name` | `string` | Yes | Name of the resource group |

### DevBox Definition Configuration Options
```hcl
dev_center_dev_box_definitions = {
  definition1 = {
    name = "windows11-dev"
    dev_center = {
      key = "devcenter1"
    }
    image_reference = {
      offer     = "windows-11"
      publisher = "microsoftwindowsdesktop"
      sku       = "win11-22h2-ent"
      version   = "latest"
    }
    sku_name = "general_i_8c32gb256ssd_v2"
    hibernate_support = {
      enabled = true
    }
    tags = {
      environment = "demo"
    }
  }
}
```

## Dev Center Project Module

### Purpose
Creates projects within an Azure Dev Center for organizing and managing development resources.

### Usage
```hcl
module "dev_center_projects" {
  source   = "./modules/dev_center_project"
  for_each = var.dev_center_projects

  global_settings     = var.global_settings
  project             = each.value
  dev_center_id       = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
  location            = lookup(each.value, "region", null) != null ? each.value.region : module.resource_groups[each.value.resource_group.key].location
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `project` | `object` | Yes | Project configuration object |
| `dev_center_id` | `string` | Yes | The ID of the Dev Center |
| `resource_group_name` | `string` | Yes | Name of the resource group |
| `location` | `string` | Yes | Azure region for deployment |

### Project Configuration Options
```hcl
dev_center_projects = {
  project1 = {
    name = "devproject"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "Development project for the engineering team"
    maximum_dev_boxes_per_user = 3
    dev_box_definition_names   = ["windows11-dev"]
    identity = {
      type = "SystemAssigned"
    }
    tags = {
      environment = "demo"
    }
  }
}
```

## Dev Center Environment Type Module

### Purpose
Creates environment types within an Azure Dev Center for defining the available environments.

### Usage
```hcl
module "dev_center_environment_types" {
  source   = "./modules/dev_center_environment_type"
  for_each = var.dev_center_environment_types

  global_settings   = var.global_settings
  environment_type  = each.value
  dev_center_id     = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `environment_type` | `object` | Yes | Environment type configuration object |
| `dev_center_id` | `string` | Yes | The ID of the Dev Center |

### Environment Type Configuration Options
```hcl
dev_center_environment_types = {
  envtype1 = {
    name = "terraform-env"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "demo"
    }
  }
}
```

## Dev Center Project Environment Type Module

### Purpose
Links environment types to projects within an Azure Dev Center.

### Usage
```hcl
module "dev_center_project_environment_types" {
  source   = "./modules/dev_center_project_environment_type"
  for_each = var.dev_center_project_environment_types

  global_settings          = var.global_settings
  project_environment_type = each.value
  location                 = lookup(each.value, "location", null) != null ? each.value.location : module.resource_groups[each.value.resource_group.key].location
  dev_center_project_id    = lookup(each.value, "dev_center_project_id", null) != null ? each.value.dev_center_project_id : module.dev_center_projects[each.value.project.key].id
  deployment_target_id     = each.value.deployment_target_id
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `project_environment_type` | `object` | Yes | Project environment type configuration object |
| `location` | `string` | Yes | Azure region for deployment |
| `dev_center_project_id` | `string` | Yes | The ID of the project |
| `deployment_target_id` | `string` | Yes | The ID of the deployment target |

### Project Environment Type Configuration Options
```hcl
dev_center_project_environment_types = {
  projenvtype1 = {
    name = "terraform-env"
    project = {
      key = "project1"
    }
    environment_type = {
      key = "envtype1"
    }
    tags = {
      environment = "demo"
    }
  }
}
```

## Dev Center Network Connection Module

### Purpose
Creates network connections for a Dev Center to enable connectivity to a virtual network.

### Usage
```hcl
module "dev_center_network_connections" {
  source   = "./modules/dev_center_network_connection"
  for_each = var.dev_center_network_connections

  global_settings     = var.global_settings
  network_connection  = each.value
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
  location            = lookup(each.value, "region", null) != null ? each.value.region : module.resource_groups[each.value.resource_group.key].location
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `network_connection` | `object` | Yes | Network connection configuration object |
| `resource_group_name` | `string` | Yes | Name of the resource group |
| `location` | `string` | Yes | Azure region for deployment |

### Network Connection Configuration Options
```hcl
dev_center_network_connections = {
  network1 = {
    name = "vnet-connection"
    dev_center = {
      key = "devcenter1"
    }
    network_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/my-vnet"
    subnet_resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
    domain_join = {
      domain_name               = "contoso.com"
      domain_username           = "admin"
      domain_password_secret_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/my-keyvault/secrets/domain-password"
      organizational_unit_path  = "OU=DevBoxes,DC=contoso,DC=com"
    }
    tags = {
      environment = "demo"
    }
  }
}
```

## Dev Center Gallery Module

### Purpose
Connects shared image galleries to a Dev Center for custom VM images.

### Usage
```hcl
module "dev_center_galleries" {
  source   = "./modules/dev_center_gallery"
  for_each = var.dev_center_galleries

  global_settings     = var.global_settings
  gallery             = each.value
  dev_center_id       = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `gallery` | `object` | Yes | Gallery configuration object |
| `dev_center_id` | `string` | Yes | The ID of the Dev Center |
| `resource_group_name` | `string` | Yes | Name of the resource group |

### Gallery Configuration Options
```hcl
dev_center_galleries = {
  gallery1 = {
    name = "devgallery"
    dev_center = {
      key = "devcenter1"
    }
    gallery_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/gallery-rg/providers/Microsoft.Compute/galleries/my-gallery"
    tags = {
      environment = "demo"
    }
  }
}
```

## Dev Center Catalog Module

### Purpose
Creates catalogs within a Dev Center for organizing DevBox templates.

### Usage
```hcl
module "dev_center_catalogs" {
  source   = "./modules/dev_center_catalog"
  for_each = var.dev_center_catalogs

  global_settings     = var.global_settings
  catalog             = each.value
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
  dev_center_id       = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
}
```

### Input Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `global_settings` | `object` | Yes | Global settings for naming and prefixing |
| `catalog` | `object` | Yes | Catalog configuration object |
| `resource_group_name` | `string` | Yes | Name of the resource group |
| `dev_center_id` | `string` | Yes | The ID of the Dev Center |

### Catalog Configuration Options
```hcl
dev_center_catalogs = {
  catalog1 = {
    name = "default-catalog"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "demo"
    }
  }
}
```
