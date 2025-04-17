// filepath: /Users/arnaud/Documents/github/arnaudlh/devfactory/examples/dev_center/dual_identity/configuration.tfvars
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
    name   = "devfactory-dualid-demo"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "devcenter-dual-identity-example"
    }
  }
}

# Note: This example demonstrates a dev center with both system-assigned and user-assigned identities
# In a real scenario, you would create a user-assigned managed identity first
dev_centers = {
  devcenter1 = {
    name = "dualid-demo"
    resource_group = {
      key = "rg1"
    }
    region = "eastus"

    # Dual identity configuration (both system and user-assigned)
    identity = {
      type = "SystemAssigned, UserAssigned"
      identity_ids = [
        "/subscriptions/$(ARM_SUBSCRIPTION_ID)/resourceGroups/identity-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/devcenter-identity1",
        "/subscriptions/$(ARM_SUBSCRIPTION_ID)/resourceGroups/identity-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/devcenter-identity2"
      ]
    }

    tags = {
      purpose        = "dual-identity-example"
      security_level = "enhanced"
    }
  }
}
