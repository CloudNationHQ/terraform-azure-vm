variable "instance" {
  description = "contains all virtual machine config"
  type        = any

  validation {
    condition     = contains(["windows", "linux"], lookup(var.instance, "type", ""))
    error_message = "The vm type must be either 'windows' or 'linux'."
  }

  validation {
    condition = (
      var.instance.type == "windows" && (
        !can(var.instance.secrets) || can(var.instance.secrets.password)
      )
      ) || (
      var.instance.type == "linux" && (
        !can(var.instance.secrets) || can(var.instance.secrets.public_key || can(var.instance.secrets.password))
      )
    )
    error_message = "For Windows instances, 'secrets' must contain 'password'. For Linux instances, 'secrets' must contain 'public_key' or 'password'."
  }
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
  default     = {}
}

variable "keyvault" {
  description = "keyvault id to store secrets"
  type        = string
  default     = null
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

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
