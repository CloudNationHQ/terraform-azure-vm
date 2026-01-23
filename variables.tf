variable "instance" {
  description = "Contains all virtual machine configuration"
  type = object({
    name                                                   = string
    type                                                   = string
    resource_group_name                                    = optional(string)
    location                                               = optional(string)
    size                                                   = optional(string, "Standard_D2s_v3")
    computer_name                                          = optional(string)
    username                                               = optional(string, "adminuser")
    password                                               = optional(string)
    public_key                                             = optional(string)
    license_type                                           = optional(string)
    allow_extension_operations                             = optional(bool, true)
    availability_set_id                                    = optional(string)
    custom_data                                            = optional(string)
    user_data                                              = optional(string)
    capacity_reservation_group_id                          = optional(string)
    virtual_machine_scale_set_id                           = optional(string)
    proximity_placement_group_id                           = optional(string)
    dedicated_host_group_id                                = optional(string)
    platform_fault_domain                                  = optional(number)
    source_image_id                                        = optional(string)
    dedicated_host_id                                      = optional(string)
    max_bid_price                                          = optional(number)
    edge_zone                                              = optional(string)
    disable_password_authentication                        = optional(bool, true)
    encryption_at_host_enabled                             = optional(bool, false)
    extensions_time_budget                                 = optional(string)
    patch_assessment_mode                                  = optional(string, "ImageDefault")
    patch_mode                                             = optional(string)
    priority                                               = optional(string, "Regular")
    provision_vm_agent                                     = optional(bool, true)
    reboot_setting                                         = optional(string)
    secure_boot_enabled                                    = optional(bool, false)
    vtpm_enabled                                           = optional(bool, false)
    zone                                                   = optional(string)
    bypass_platform_safety_checks_on_user_schedule_enabled = optional(bool, false)
    disk_controller_type                                   = optional(string)
    eviction_policy                                        = optional(string)
    os_managed_disk_id                                     = optional(string)
    tags                                                   = optional(map(string))
    additional_capabilities = optional(object({
      ultra_ssd_enabled   = optional(bool, false)
      hibernation_enabled = optional(bool, false)
    }), null)
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
    interfaces = map(object({
      name                           = optional(string)
      dns_servers                    = optional(list(string), [])
      accelerated_networking_enabled = optional(bool, false)
      ip_forwarding_enabled          = optional(bool, false)
      ip_config_name                 = optional(string, "ipconfig")
      private_ip_address_allocation  = optional(string, "Dynamic")
      private_ip_address             = optional(string)
      private_ip_address_version     = optional(string, "IPv4")
      public_ip_address_id           = optional(string)
      auxiliary_sku                  = optional(string)
      auxiliary_mode                 = optional(string)
      internal_dns_name_label        = optional(string)
      edge_zone                      = optional(string)
      tags                           = optional(map(string))
      ip_configurations = map(object({
        name                                               = optional(string)
        private_ip_address                                 = optional(string)
        public_ip_address_id                               = optional(string)
        private_ip_address_version                         = optional(string, "IPv4")
        subnet_id                                          = optional(string)
        primary                                            = optional(bool, false)
        gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      }))
    }))
    generate_ssh_key = optional(object({
      enable           = optional(bool, false)
      algorithm        = optional(string, "RSA")
      rsa_bits         = optional(number, 4096)
      ecdsa_curve      = optional(string)
      expiration_date  = optional(string)
      not_before_date  = optional(string)
      value_wo_version = optional(number)
      value_wo         = optional(string)
      content_type     = optional(string)
    }), { enable = false })
    generate_password = optional(object({
      enable           = optional(bool, false)
      length           = optional(number, 24)
      special          = optional(bool, true)
      min_lower        = optional(number, 5)
      min_upper        = optional(number, 7)
      min_special      = optional(number, 4)
      min_numeric      = optional(number, 5)
      numeric          = optional(bool)
      upper            = optional(bool)
      lower            = optional(bool)
      override_special = optional(string)
      expiration_date  = optional(string)
      not_before_date  = optional(string)
      value_wo_version = optional(number)
      value_wo         = optional(string)
      content_type     = optional(string)
      keepers          = optional(map(string))
    }), { enable = false })
    os_disk = optional(object({
      name                             = optional(string)
      storage_account_type             = optional(string, "StandardSSD_LRS")
      caching                          = optional(string, "ReadWrite")
      disk_size_gb                     = optional(number)
      security_encryption_type         = optional(string)
      write_accelerator_enabled        = optional(bool, false)
      disk_encryption_set_id           = optional(string)
      secure_vm_disk_encryption_set_id = optional(string)
      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string)
      }), null)
    }), {})
    source_image_reference = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string, "latest")
    }), null)
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }), null)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }), null)
    disks = optional(map(object({
      name                              = optional(string)
      create_option_disk_attachment     = optional(string, "Attach")
      create_option                     = optional(string, "Empty")
      disk_size_gb                      = optional(number, 10)
      storage_account_type              = optional(string, "Standard_LRS")
      caching                           = optional(string, "ReadWrite")
      tags                              = optional(map(string))
      lun                               = number
      tier                              = optional(string)
      zone                              = optional(string)
      os_type                           = optional(string)
      edge_zone                         = optional(string)
      max_shares                        = optional(number)
      source_uri                        = optional(string)
      optimized_frequent_attach_enabled = optional(bool)
      public_network_access_enabled     = optional(bool)
      on_demand_bursting_enabled        = optional(bool, false)
      gallery_image_reference_id        = optional(string)
      performance_plus_enabled          = optional(bool)
      trusted_launch_enabled            = optional(bool, false)
      network_access_policy             = optional(string)
      logical_sector_size               = optional(number)
      source_resource_id                = optional(string)
      image_reference_id                = optional(string)
      secure_vm_disk_encryption_set_id  = optional(string)
      disk_encryption_set_id            = optional(string)
      security_type                     = optional(string)
      disk_access_id                    = optional(string)
      hyper_v_generation                = optional(string)
      disk_iops_read_write              = optional(number)
      disk_mbps_read_write              = optional(number)
      storage_account_id                = optional(string)
      write_accelerator_enabled         = optional(bool, false)
      disk_iops_read_only               = optional(number)
      disk_mbps_read_only               = optional(number)
      upload_size_bytes                 = optional(number)
    })), {})
    extensions = optional(map(object({
      name                        = optional(string)
      publisher                   = string
      type                        = string
      type_handler_version        = string
      settings                    = optional(map(any), {})
      protected_settings          = optional(map(string), {})
      auto_upgrade_minor_version  = optional(bool, true)
      automatic_upgrade_enabled   = optional(bool, false)
      failure_suppression_enabled = optional(bool, false)
      provision_after_extensions  = optional(list(string), [])
      protected_settings_from_key_vault = optional(object({
        secret_url      = string
        source_vault_id = string
      }))
      tags = optional(map(string))
    })), {})
    automatic_updates_enabled = optional(bool, true)
    hotpatching_enabled       = optional(bool, false)
    timezone                  = optional(string)
    winrm_listeners = optional(map(object({
      protocol        = string
      certificate_url = optional(string)
    })), {})
    secrets = optional(map(object({
      key_vault_id = string
      certificate = object({
        url   = string
        store = optional(string)
      })
    })), {})
    os_image_notification = optional(object({
      timeout = string
    }), null)
    gallery_applications = optional(map(object({
      tag                                         = optional(string)
      order                                       = optional(number)
      version_id                                  = string
      configuration_blob_uri                      = optional(string)
      automatic_upgrade_enabled                   = optional(bool, false)
      treat_failure_as_deployment_failure_enabled = optional(bool, false)
    })), {})
    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string)
    }), null)
    additional_unattend_content = optional(map(object({
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
    condition     = var.instance.resource_group_name != null || var.resource_group_name != null
    error_message = "Resource group name must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = try(var.instance.source_image_reference, null) != null || try(var.source_image_reference, null) != null || try(var.instance.source_image_id, null) != null
    error_message = "Source image information must be provided either as source_image_id, in the instance.source_image_reference object, or as a separate source_image_reference variable."
  }

  validation {
    condition = alltrue([
      for secret in try(var.instance.secrets, {}) :
      var.instance.type == "windows"
      ? secret.certificate.store != null
      : lookup(secret.certificate, "store", null) == null
    ])
    error_message = "For Linux instances omit the certificate store; for Windows instances provide a certificate store value."
  }
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "default azure region and can be used if location is not specified inside the object."
  type        = string
  default     = null
}

variable "resource_group_name" {
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
