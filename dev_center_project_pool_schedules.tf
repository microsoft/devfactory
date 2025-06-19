# DevCenter Project Pool Schedules Configuration
# This file instantiates the dev_center_project_pool_schedule module
# Schedules are managed separately from pools for better reusability

# Create DevCenter project pool schedules
module "dev_center_project_pool_schedules" {
  source = "./modules/dev_center_project_pool_schedule"

  for_each = var.dev_center_project_pool_schedules

  # Reference the pool ID - use provided ID or reference from pool module
  dev_center_project_pool_id = lookup(each.value, "dev_center_project_pool_id", null) != null ? each.value.dev_center_project_pool_id : module.dev_center_project_pools[each.value.dev_center_project_pool.key].id

  # Schedule configuration
  schedule = each.value.schedule

  # Pass through global settings
  global_settings = var.global_settings
}
