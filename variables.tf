variable "vm" {
  description = "contains all virtual machine config"
  type        = any

  validation {
    condition     = contains(["windows", "linux"], lookup(var.vm, "type", ""))
    error_message = "The vm type must be either 'windows' or 'linux'."
  }
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
}

variable "keyvault" {
  description = "keyvault to store secrets"
  type        = string
}

variable "location" {
  description = "default azure region and can be used if location is not specified inside the object."
  type        = string
  default     = null
}

variable "resourcegroup" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}
