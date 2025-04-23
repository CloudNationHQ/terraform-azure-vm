variable "instance" {
  description = "Contains all virtual machine configuration"
  type = object({
    name                                                   = string
    type                                                   = string
    resource_group                                         = optional(string, null)
    location                                               = optional(string, null)
    size                                                   = optional(string, "Standard_D2s_v3")
    computer_name                                          = optional(string, null)
    username                                               = optional(string, "adminuser")
    admin_username                                         = optional(string, "adminuser")
    password                                               = optional(string, null)
    public_key                                             = optional(string, null)
    license_type                                           = optional(string, null)
    allow_extension_operations                             = optional(bool, true)
    availability_set_id                                    = optional(string, null)
    custom_data                                            = optional(string, null)
    user_data                                              = optional(string, null)
    capacity_reservation_group_id                          = optional(string, null)
    virtual_machine_scale_set_id                           = optional(string, null)
    proximity_placement_group_id                           = optional(string, null)
    dedicated_host_group_id                                = optional(string, null)
    platform_fault_domain                                  = optional(number, null)
    source_image_id                                        = optional(string, null)
    dedicated_host_id                                      = optional(string, null)
    max_bid_price                                          = optional(number, null)
    edge_zone                                              = optional(string, null)
    disable_password_authentication                        = optional(bool, true)
    encryption_at_host_enabled                             = optional(bool, false)
    extensions_time_budget                                 = optional(string, null)
    patch_assessment_mode                                  = optional(string, "ImageDefault")
    patch_mode                                             = optional(string, null)
    priority                                               = optional(string, "Regular")
    provision_vm_agent                                     = optional(bool, true)
    reboot_setting                                         = optional(string, null)
    secure_boot_enabled                                    = optional(bool, false)
    vtpm_enabled                                           = optional(bool, false)
    zone                                                   = optional(string, null)
    bypass_platform_safety_checks_on_user_schedule_enabled = optional(bool, false)
    provisioning_vm_agent                                  = optional(bool, true)
    disk_controller_type                                   = optional(string, null)
    eviction_policy                                        = optional(string, null)
    tags                                                   = optional(map(string))
    additional_capabilities = optional(object({
      ultra_ssd_enabled   = optional(bool, false)
      hibernation_enabled = optional(bool, false)
    }), null)
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string, null)
    }), null)
    interfaces = map(object({
      name                           = optional(string)
      dns_servers                    = optional(list(string), [])
      accelerated_networking_enabled = optional(bool, false)
      ip_forwarding_enabled          = optional(bool, false)
      ip_config_name                 = optional(string, "ipconfig")
      private_ip_address_allocation  = optional(string, "Dynamic")
      private_ip_address             = optional(string, null)
      private_ip_address_version     = optional(string, "IPv4")
      public_ip_address_id           = optional(string, null)
      auxiliary_sku                  = optional(string, null)
      auxiliary_mode                 = optional(string, null)
      internal_dns_name_label        = optional(string, null)
      edge_zone                      = optional(string, null)
      tags                           = optional(map(string), null)
      ip_configurations = map(object({
        name                                               = optional(string)
        private_ip_address                                 = optional(string, null)
        public_ip_address_id                               = optional(string, null)
        private_ip_address_version                         = optional(string, "IPv4")
        subnet_id                                          = optional(string, null)
        primary                                            = optional(bool, false)
        gateway_load_balancer_frontend_ip_configuration_id = optional(string, null)
      }))
    }))
    generate_ssh_key = optional(object({
      enable           = optional(bool, false)
      algorithm        = optional(string, "RSA")
      rsa_bits         = optional(number, 4096)
      ecdsa_curve      = optional(string, null)
      expiration_date  = optional(string, null)
      not_before_date  = optional(string, null)
      value_wo_version = optional(number, null)
      value_wo         = optional(string, null)
      content_type     = optional(string, null)
    }), { enable = false })
    generate_password = optional(object({
      enable           = optional(bool, false)
      length           = optional(number, 24)
      special          = optional(bool, true)
      min_lower        = optional(number, 5)
      min_upper        = optional(number, 7)
      min_special      = optional(number, 4)
      min_numeric      = optional(number, 5)
      numeric          = optional(bool, null)
      upper            = optional(bool, null)
      lower            = optional(bool, null)
      override_special = optional(string, null)
      expiration_date  = optional(string, null)
      not_before_date  = optional(string, null)
      value_wo_version = optional(number, null)
      value_wo         = optional(string, null)
      content_type     = optional(string, null)
      keepers          = optional(map(string), null)
    }), { enable = false })
    os_disk = optional(object({
      name                             = optional(string, null)
      storage_account_type             = optional(string, "Standard_LRS")
      caching                          = optional(string, "ReadWrite")
      disk_size_gb                     = optional(number, null)
      security_encryption_type         = optional(string, null)
      write_accelerator_enabled        = optional(bool, false)
      disk_encryption_set_id           = optional(string, null)
      secure_vm_disk_encryption_set_id = optional(string, null)
      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string, null)
      }), null)
    }), {})
    source_image_reference = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string)
      # publisher = optional(string, null)
      # offer     = optional(string, null)
      # sku       = optional(string, null)
      # version   = optional(string, null)
    }), null)
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }), null)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }), null)
    disks = optional(map(object({
      name                              = optional(string, null)
      create_option_disk_attachment     = optional(string, "Attach")
      create_option                     = optional(string, "Empty")
      disk_size_gb                      = optional(number, 10)
      storage_account_type              = optional(string, "Standard_LRS")
      caching                           = optional(string, "ReadWrite")
      tags                              = optional(map(string), null)
      lun                               = number
      tier                              = optional(string, null)
      zone                              = optional(string, null)
      os_type                           = optional(string, null)
      edge_zone                         = optional(string, null)
      max_shares                        = optional(number, null)
      source_uri                        = optional(string, null)
      optimized_frequent_attach_enabled = optional(bool, null)
      public_network_access_enabled     = optional(bool, null)
      on_demand_bursting_enabled        = optional(bool, false)
      gallery_image_reference_id        = optional(string, null)
      performance_plus_enabled          = optional(bool, null)
      trusted_launch_enabled            = optional(bool, false)
      network_access_policy             = optional(string, null)
      logical_sector_size               = optional(number, null)
      source_resource_id                = optional(string, null)
      image_reference_id                = optional(string, null)
      secure_vm_disk_encryption_set_id  = optional(string, null)
      disk_encryption_set_id            = optional(string, null)
      security_type                     = optional(string, null)
      disk_access_id                    = optional(string, null)
      hyper_v_generation                = optional(string, null)
      disk_iops_read_write              = optional(number, null)
      disk_mbps_read_write              = optional(number, null)
      storage_account_id                = optional(string, null)
      write_accelerator_enabled         = optional(bool, false)
      disk_iops_read_only               = optional(number, null)
      disk_mbps_read_only               = optional(number, null)
      upload_size_bytes                 = optional(number, null)
    })), {})
    extensions = optional(map(object({
      name                 = optional(string, null)
      publisher            = string
      type                 = string
      type_handler_version = string
      settings             = optional(any, null)
      protected_settings   = optional(any, null)
      # settings                    = optional(string, null)
      # protected_settings          = optional(string, null)
      auto_upgrade_minor_version  = optional(bool, true)
      automatic_upgrade_enabled   = optional(bool, false)
      failure_suppression_enabled = optional(bool, false)
      provision_after_extensions  = optional(list(string), [])
      tags                        = optional(map(string), null)
    })), {})
    enable_automatic_updates = optional(bool, true)
    hotpatching_enabled      = optional(bool, false)
    timezone                 = optional(string, null)
    winrm_listeners = optional(map(object({
      protocol        = string
      certificate_url = optional(string, null)
    })), {})
    secrets = optional(map(object({
      key_vault_id = string
      certificate = object({
        url   = string
        store = string
      })
    })), {})
    os_image_notification = optional(object({
      timeout = string
    }), null)
    gallery_applications = optional(map(object({
      tag                                         = optional(string, null)
      order                                       = optional(number, null)
      version_id                                  = string
      configuration_blob_uri                      = optional(string, null)
      automatic_upgrade_enabled                   = optional(bool, false)
      treat_failure_as_deployment_failure_enabled = optional(bool, false)
    })), {})
    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string, null)
    }), null)
    addtional_unattend_contents = optional(map(object({
      content = string
      setting = string
    })), {})
  })

  validation {
    condition     = contains(["linux", "windows"], var.instance.type)
    error_message = "The instance type must be either 'linux' or 'windows'."
  }

  validation {
    condition     = var.instance.location != null || var.location != null
    error_message = "Location must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = var.instance.resource_group != null || var.resource_group != null
    error_message = "Resource group name must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = try(var.instance.source_image_reference, null) != null || try(var.source_image_reference, null) != null || try(var.instance.source_image_id, null) != null
    error_message = "Source image information must be provided either as source_image_id, in the instance.source_image_reference object, or as a separate source_image_reference variable."
  }

  validation {
    condition = alltrue([
      for secret in try(var.instance.secrets, {}) :
      var.instance.type == "windows" || lookup(secret.certificate, "store", null) == null
    ])
    error_message = "Certificate store is only applicable when instance type is 'windows'. Remove the store property for Linux instances."
  }

  validation {
    condition = (
      var.instance.type == "windows" && (
        try(var.instance.password, null) != null ||
        try(var.instance.generate_password.enable, false) == true
      )
      ) || (
      var.instance.type == "linux" && (
        try(var.instance.public_key, null) != null ||
        try(var.instance.generate_ssh_key.enable, false) == true ||
        try(var.instance.password, null) != null
      )
    )
    error_message = join(" ", [
      "Invalid authentication configuration.",
      "Windows VMs must have either 'password' specified or 'generate_password.enable=true'.",
      "Linux VMs must either use SSH key auth (via 'public_key' or 'generate_ssh_key.enable=true')",
      "or provide a 'password'."
    ])
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

variable "resource_group" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}

variable "source_image_reference" {
  description = "Default source image reference configuration to use when not specified at the instance level"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}
