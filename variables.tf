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
  description = "location of the resource group"
  type        = string
}

variable "resourcegroup" {
  description = "contains the resource group name"
  type        = string
}
