// filepath: /Users/arnaud/Documents/github/arnaudlh/devfactory/examples/dev_center/user_assigned_identity/configuration.tfvars
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
    name   = "devfactory-userid-demo"
    region = "eastus"
    tags = {
      environment = "development"
      workload    = "devcenter-user-identity-example"
    }
  }
}

# Note: In a real scenario, you would create a user-assigned managed identity first
# This example assumes a user-assigned identity already exists with the ID below
# Replace with your actual user-assigned identity ID
dev_centers = {
  devcenter1 = {
    name = "userid-demo"
    resource_group = {
      key = "rg1"
    }
    region = "eastus"

    # User assigned identity configuration
    identity = {
      type = "UserAssigned"
      identity_ids = [
        "/subscriptions/$(ARM_SUBSCRIPTION_ID)/resourceGroups/identity-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/devcenter-identity"
      ]
    }

    tags = {
      purpose = "user-identity-example"
    }
  }
}
