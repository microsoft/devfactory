# Dev Center Projects module instantiation
module "dev_center_projects" {
  source   = "./modules/dev_center_project"
  for_each = try(var.dev_center_projects, {})

  global_settings   = var.global_settings
  project           = each.value
  dev_center_id     = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
  resource_group_id = lookup(each.value, "resource_group_id", null) != null ? each.value.resource_group_id : module.resource_groups[each.value.resource_group.key].id
  location          = lookup(each.value, "region", null) != null ? each.value.region : module.resource_groups[each.value.resource_group.key].location
}
