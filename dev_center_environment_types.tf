# Dev Center Environment Types module instantiation
module "dev_center_environment_types" {
  source   = "./modules/dev_center_environment_type"
  for_each = try(var.dev_center_environment_types, {})

  global_settings  = var.global_settings
  environment_type = each.value
  dev_center_id    = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
}
