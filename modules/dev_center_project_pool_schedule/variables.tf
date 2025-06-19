# DevCenter Project Pool Schedule Module Variables
# Variables for creating Azure DevCenter project pool schedules

variable "global_settings" {
  description = "Global settings for the module"
  type = object({
    prefixes      = optional(list(string), [])
    random_length = optional(number, 0)
    passthrough   = optional(bool, false)
    use_slug      = optional(bool, true)
    tags          = optional(map(string), {})
  })
  default = {}
}

variable "dev_center_project_pool_id" {
  description = "The resource ID of the DevCenter project pool"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/[^/]+/providers/Microsoft.DevCenter/projects/[^/]+/pools/[^/]+$", var.dev_center_project_pool_id))
    error_message = "The dev_center_project_pool_id must be a valid Azure DevCenter project pool resource ID."
  }
}

variable "schedule" {
  description = "Configuration for the DevCenter project pool schedule"
  type = object({
    name      = string
    type      = optional(string, "StopDevBox") # StopDevBox, StartDevBox
    frequency = optional(string, "Daily")      # Daily, Weekly
    time      = string                         # HH:MM format (24-hour)
    time_zone = string                         # Time zone (e.g., "W. Europe Standard Time")
    state     = optional(string, "Enabled")    # Enabled, Disabled
    tags      = optional(map(string), {})
  })

  validation {
    condition     = can(regex("^[0-2][0-9]:[0-5][0-9]$", var.schedule.time))
    error_message = "The time must be in HH:MM format (24-hour)."
  }

  validation {
    condition     = contains(["StopDevBox", "StartDevBox"], var.schedule.type)
    error_message = "The schedule type must be either 'StopDevBox' or 'StartDevBox'."
  }

  validation {
    condition     = contains(["Daily", "Weekly"], var.schedule.frequency)
    error_message = "The schedule frequency must be either 'Daily' or 'Weekly'."
  }

  validation {
    condition     = contains(["Enabled", "Disabled"], var.schedule.state)
    error_message = "The schedule state must be either 'Enabled' or 'Disabled'."
  }
}
