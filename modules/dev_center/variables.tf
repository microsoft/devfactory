variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
  })
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Dev Center"
  type        = string
}

variable "location" {
  description = "The location/region where the Dev Center is created"
  type        = string
}

variable "dev_center" {
  description = "Configuration object for the Dev Center"
  type = object({
    name = string
  })
}
