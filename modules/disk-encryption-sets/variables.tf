variable "encryption_sets" {
  description = "Contains all disk encryption sets configuration"
  type = map(object({
    name                      = optional(string)
    location                  = optional(string)
    resource_group_name       = optional(string)
    key_vault_key_id          = optional(string)
    managed_hsm_key_id        = optional(string)
    encryption_type           = optional(string)
    auto_key_rotation_enabled = optional(bool, false)
    federated_client_id       = optional(string)
    identity = optional(object({
      type         = optional(string, "SystemAssigned")
      identity_ids = optional(list(string))
    }), { type = "SystemAssigned" })
    tags = optional(map(string))
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

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
