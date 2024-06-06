variable "disk_encryption_sets" {
  description = "describes disk all encryption sets"
  type        = any
  default     = {}
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
  default     = null
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resourcegroup" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
