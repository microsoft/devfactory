# Resource groups module instantiation
module "resource_groups" {
  source   = "./modules/resource_group"
  for_each = try(var.resource_groups, {})

  global_settings = var.global_settings
  resource_group  = each.value
  tags            = try(each.value.tags, {})
}
