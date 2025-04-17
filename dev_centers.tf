# Dev Centers module instantiation
module "dev_centers" {
  source   = "./modules/dev_center"
  for_each = try(var.dev_centers, {})

  global_settings     = var.global_settings
  dev_center          = each.value
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
  location            = lookup(each.value, "region", null) != null ? each.value.region : module.resource_groups[each.value.resource_group.key].location
}
