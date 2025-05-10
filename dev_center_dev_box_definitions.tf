# Dev Center Dev Box Definitions module instantiation
module "dev_center_dev_box_definitions" {
  source   = "./modules/dev_center_dev_box_definition"
  for_each = try(var.dev_center_dev_box_definitions, {})

  global_settings    = var.global_settings
  dev_box_definition = each.value
  dev_center_id      = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
  location           = lookup(each.value, "region", null) != null ? each.value.region : module.resource_groups[each.value.resource_group.key].location
}
