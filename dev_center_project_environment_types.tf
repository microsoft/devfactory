# Dev Center Project Environment Types module instantiation
module "dev_center_project_environment_types" {
  source   = "./modules/dev_center_project_environment_type"
  for_each = try(var.dev_center_project_environment_types, {})

  global_settings          = var.global_settings
  project_environment_type = each.value
  dev_center_project_id    = lookup(each.value, "dev_center_project_id", null) != null ? each.value.dev_center_project_id : module.dev_center_projects[each.value.project.key].id
  environment_type_name    = lookup(each.value, "environment_type_name", null) != null ? each.value.environment_type_name : module.dev_center_environment_types[each.value.environment_type.key].name
}