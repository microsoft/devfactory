variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
  })
}

variable "resource_group" {
  description = "Configuration object for the resource group"
  type = object({
    name   = string
    region = string
    tags   = optional(map(string), {})
  })
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
