variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
  })
}

variable "dev_center_id" {
  description = "The ID of the Dev Center in which to create the project"
  type        = string
}

variable "location" {
  description = "The location/region where the Dev Center Project is created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Dev Center Project"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Configuration object for the Dev Center Project"
  type = object({
    name                       = string
    description                = optional(string)
    maximum_dev_boxes_per_user = optional(number)
    tags                       = optional(map(string))
  })
}
