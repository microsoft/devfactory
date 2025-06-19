# DevCenter Project Pools module instantiation
module "dev_center_project_pools" {
  source   = "./modules/dev_center_project_pool"
  for_each = try(var.dev_center_project_pools, {})

  global_settings = var.global_settings
  pool = merge(each.value, {
    dev_box_definition_name = module.dev_center_dev_box_definitions[each.value.dev_box_definition_name].name
  })
  dev_center_project_id = lookup(each.value, "dev_center_project_id", null) != null ? each.value.dev_center_project_id : module.dev_center_projects[each.value.dev_center_project.key].id
  resource_group_id     = lookup(each.value, "resource_group_id", null) != null ? each.value.resource_group_id : module.resource_groups[each.value.resource_group.key].id
  location              = lookup(each.value, "region", null) != null ? each.value.region : module.resource_groups[each.value.resource_group.key].location
}
