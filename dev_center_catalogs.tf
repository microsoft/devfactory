# Dev Center Catalogs module instantiation
module "dev_center_catalogs" {
  source   = "./modules/dev_center_catalog"
  for_each = try(var.dev_center_catalogs, {})

  global_settings = var.global_settings
  catalog         = each.value
  dev_center_id = coalesce(
    lookup(each.value, "dev_center_id", null),
    try(module.dev_centers[each.value.dev_center.key].id, null)
  )

  depends_on = [
    module.dev_centers
  ]
}
