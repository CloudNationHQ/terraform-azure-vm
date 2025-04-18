variable "availability_sets" {
  description = "Contains all availabiliy sets configuration"
  type = map(object({
    name                         = optional(string)
    location                     = optional(string)
    resource_group               = optional(string)
    managed                      = optional(bool, true)
    platform_fault_domain_count  = optional(number, 3)
    platform_update_domain_count = optional(number, 5)
    proximity_placement_group_id = optional(string, null)
    tags                         = optional(map(string))
  }))
  default = null
}

variable "naming" {
  description = "Used for naming purposes"
  type        = map(string)
  default     = null
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
