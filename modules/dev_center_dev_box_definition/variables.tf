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

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "dev_box_definition" {
  description = "Configuration object for the Dev Box Definition"
  type = object({
    name               = string
    image_reference_id = string
    sku_name           = string
    tags               = optional(map(string))
  })
}
