# linux vm
resource "azurerm_linux_virtual_machine" "this" {
  for_each = var.instance.type == "linux" ? { "vm" = true } : {}

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  computer_name = try(
    var.instance.computer_name, var.instance.name
  )

  name                          = var.instance.name
  size                          = var.instance.size
  admin_username                = var.instance.username
  admin_password                = var.instance.password
  license_type                  = var.instance.license_type
  allow_extension_operations    = var.instance.allow_extension_operations
  availability_set_id           = var.instance.availability_set_id
  custom_data                   = var.instance.custom_data
  user_data                     = var.instance.user_data
  capacity_reservation_group_id = var.instance.capacity_reservation_group_id
  virtual_machine_scale_set_id  = var.instance.virtual_machine_scale_set_id
  proximity_placement_group_id  = var.instance.proximity_placement_group_id
  dedicated_host_group_id       = var.instance.dedicated_host_group_id
  platform_fault_domain         = var.instance.platform_fault_domain
  source_image_id               = var.instance.source_image_id
  dedicated_host_id             = var.instance.dedicated_host_id
  max_bid_price                 = var.instance.max_bid_price
  edge_zone                     = var.instance.edge_zone
  encryption_at_host_enabled    = var.instance.encryption_at_host_enabled
  extensions_time_budget        = var.instance.extensions_time_budget
  patch_assessment_mode         = var.instance.patch_assessment_mode
  priority                      = var.instance.priority
  provision_vm_agent            = var.instance.provision_vm_agent
  reboot_setting                = var.instance.reboot_setting
  secure_boot_enabled           = var.instance.secure_boot_enabled
  vtpm_enabled                  = var.instance.vtpm_enabled
  eviction_policy               = var.instance.eviction_policy
  disk_controller_type          = var.instance.disk_controller_type
  os_managed_disk_id            = var.instance.os_managed_disk_id
  zone                          = var.instance.zone

  disable_password_authentication = (
    try(var.instance.password, null) != null ? false : try(var.instance.public_key, null) != null ? true : try(var.instance.disable_password_authentication, true)
  )

  tags = coalesce(
    var.instance.tags, var.tags
  )

  # diffent defaults for windows and linux
  patch_mode = try(
    var.instance.patch_mode, "ImageDefault"
  )

  bypass_platform_safety_checks_on_user_schedule_enabled = var.instance.bypass_platform_safety_checks_on_user_schedule_enabled

  dynamic "secret" {
    for_each = try(
      var.instance.secrets, {}
    )

    content {
      key_vault_id = secret.value.key_vault_id

      certificate {
        url = secret.value.certificate.url
      }
    }
  }

  dynamic "termination_notification" {
    for_each = var.instance.termination_notification != null ? [var.instance.termination_notification] : []

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  dynamic "os_image_notification" {
    for_each = var.instance.os_image_notification != null ? [var.instance.os_image_notification] : []

    content {
      timeout = os_image_notification.value.timeout
    }
  }


  dynamic "additional_capabilities" {
    for_each = var.instance.additional_capabilities != null ? [var.instance.additional_capabilities] : []

    content {
      ultra_ssd_enabled   = additional_capabilities.value.ultra_ssd_enabled
      hibernation_enabled = additional_capabilities.value.hibernation_enabled
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.instance.boot_diagnostics != null ? [var.instance.boot_diagnostics] : []

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  network_interface_ids = [
    for interface_key, nic in var.instance.interfaces :
    azurerm_network_interface.this[interface_key].id
  ]

  dynamic "admin_ssh_key" {
    for_each = try(var.instance.public_key, null) != null ? [1] : []

    content {
      username   = var.instance.username
      public_key = var.instance.public_key
    }
  }

  os_disk {
    name                             = var.instance.os_disk.name
    storage_account_type             = var.instance.os_disk.storage_account_type
    caching                          = var.instance.os_disk.caching
    disk_size_gb                     = var.instance.os_disk.disk_size_gb
    security_encryption_type         = var.instance.os_disk.security_encryption_type
    write_accelerator_enabled        = var.instance.os_disk.write_accelerator_enabled
    disk_encryption_set_id           = var.instance.os_disk.disk_encryption_set_id
    secure_vm_disk_encryption_set_id = var.instance.os_disk.secure_vm_disk_encryption_set_id

    dynamic "diff_disk_settings" {
      for_each = var.instance.os_disk.diff_disk_settings != null ? [var.instance.os_disk.diff_disk_settings] : []

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "gallery_application" {
    for_each = try(
      var.instance.gallery_applications, {}
    )

    content {
      tag                                         = gallery_application.value.tag
      order                                       = gallery_application.value.order
      version_id                                  = gallery_application.value.version_id
      configuration_blob_uri                      = gallery_application.value.configuration_blob_uri
      automatic_upgrade_enabled                   = gallery_application.value.automatic_upgrade_enabled
      treat_failure_as_deployment_failure_enabled = gallery_application.value.treat_failure_as_deployment_failure_enabled
    }
  }

  dynamic "source_image_reference" {
    for_each = try(var.instance.source_image_id, null) == null ? [true] : []

    content {
      publisher = try(
        var.instance.source_image_reference.publisher, var.source_image_reference != null ? var.source_image_reference.publisher : null
      )
      offer = try(
        var.instance.source_image_reference.offer, var.source_image_reference != null ? var.source_image_reference.offer : null
      )
      sku = try(
        var.instance.source_image_reference.sku, var.source_image_reference != null ? var.source_image_reference.sku : null
      )
      version = try(
        var.instance.source_image_reference.version, var.source_image_reference != null ? var.source_image_reference.version : null
      )
    }
  }

  dynamic "plan" {
    for_each = var.instance.plan != null ? [var.instance.plan] : []

    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  dynamic "identity" {
    for_each = lookup(var.instance, "identity", null) != null ? [var.instance.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

# windows vm
resource "azurerm_windows_virtual_machine" "this" {
  for_each = var.instance.type == "windows" ? { "vm" = true } : {}

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  computer_name = try(
    var.instance.computer_name, var.instance.name
  )

  name                          = var.instance.name
  size                          = var.instance.size
  admin_username                = var.instance.username
  admin_password                = var.instance.password
  allow_extension_operations    = var.instance.allow_extension_operations
  availability_set_id           = var.instance.availability_set_id
  custom_data                   = var.instance.custom_data
  user_data                     = var.instance.user_data
  automatic_updates_enabled     = var.instance.automatic_updates_enabled
  encryption_at_host_enabled    = var.instance.encryption_at_host_enabled
  eviction_policy               = var.instance.eviction_policy
  hotpatching_enabled           = var.instance.hotpatching_enabled
  patch_assessment_mode         = var.instance.patch_assessment_mode
  priority                      = var.instance.priority
  reboot_setting                = var.instance.reboot_setting
  secure_boot_enabled           = var.instance.secure_boot_enabled
  license_type                  = var.instance.license_type
  max_bid_price                 = var.instance.max_bid_price
  edge_zone                     = var.instance.edge_zone
  dedicated_host_id             = var.instance.dedicated_host_id
  source_image_id               = var.instance.source_image_id
  platform_fault_domain         = var.instance.platform_fault_domain
  extensions_time_budget        = var.instance.extensions_time_budget
  dedicated_host_group_id       = var.instance.dedicated_host_group_id
  proximity_placement_group_id  = var.instance.proximity_placement_group_id
  capacity_reservation_group_id = var.instance.capacity_reservation_group_id
  timezone                      = var.instance.timezone
  virtual_machine_scale_set_id  = var.instance.virtual_machine_scale_set_id
  vtpm_enabled                  = var.instance.vtpm_enabled
  zone                          = var.instance.zone
  provision_vm_agent            = var.instance.provision_vm_agent
  disk_controller_type          = var.instance.disk_controller_type
  os_managed_disk_id            = var.instance.os_managed_disk_id

  # diffent defaults for windows and linux
  patch_mode = try(
    var.instance.patch_mode, "AutomaticByOS"
  )

  tags = coalesce(
    var.instance.tags, var.tags
  )

  bypass_platform_safety_checks_on_user_schedule_enabled = var.instance.bypass_platform_safety_checks_on_user_schedule_enabled

  network_interface_ids = [
    for interface_key, nic in var.instance.interfaces :
    azurerm_network_interface.this[interface_key].id
  ]

  dynamic "winrm_listener" {
    for_each = try(
      var.instance.winrm_listeners, {}
    )

    content {
      protocol        = winrm_listener.value.protocol
      certificate_url = winrm_listener.value.certificate_url
    }
  }

  dynamic "secret" {
    for_each = try(
      var.instance.secrets, {}
    )

    content {
      key_vault_id = secret.value.key_vault_id

      certificate {
        url   = secret.value.certificate.url
        store = secret.value.certificate.store
      }
    }
  }

  dynamic "os_image_notification" {
    for_each = var.instance.os_image_notification != null ? [var.instance.os_image_notification] : []

    content {
      timeout = os_image_notification.value.timeout
    }
  }

  dynamic "gallery_application" {
    for_each = try(
      var.instance.gallery_applications, {}
    )

    content {
      tag                                         = gallery_application.value.tag
      order                                       = gallery_application.value.order
      version_id                                  = gallery_application.value.version_id
      configuration_blob_uri                      = gallery_application.value.configuration_blob_uri
      automatic_upgrade_enabled                   = gallery_application.value.automatic_upgrade_enabled
      treat_failure_as_deployment_failure_enabled = gallery_application.value.treat_failure_as_deployment_failure_enabled
    }
  }

  dynamic "termination_notification" {
    for_each = var.instance.termination_notification != null ? [var.instance.termination_notification] : []

    content {
      enabled = termination_notification.value.enabled
      timeout = termination_notification.value.timeout
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.instance.additional_capabilities != null ? [var.instance.additional_capabilities] : []

    content {
      ultra_ssd_enabled   = additional_capabilities.value.ultra_ssd_enabled
      hibernation_enabled = additional_capabilities.value.hibernation_enabled
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.instance.boot_diagnostics != null ? [var.instance.boot_diagnostics] : []

    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  os_disk {
    storage_account_type             = var.instance.os_disk.storage_account_type
    caching                          = var.instance.os_disk.caching
    disk_size_gb                     = var.instance.os_disk.disk_size_gb
    write_accelerator_enabled        = var.instance.os_disk.write_accelerator_enabled
    disk_encryption_set_id           = var.instance.os_disk.disk_encryption_set_id
    security_encryption_type         = var.instance.os_disk.security_encryption_type
    secure_vm_disk_encryption_set_id = var.instance.os_disk.secure_vm_disk_encryption_set_id
    name                             = var.instance.os_disk.name

    dynamic "diff_disk_settings" {
      for_each = var.instance.os_disk.diff_disk_settings != null ? [var.instance.os_disk.diff_disk_settings] : []

      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  dynamic "additional_unattend_content" {
    for_each = try(
      var.instance.additional_unattend_content, {}
    )

    content {
      content = additional_unattend_content.value.content
      setting = additional_unattend_content.value.setting
    }
  }

  dynamic "source_image_reference" {
    for_each = try(var.instance.source_image_id, null) == null ? [true] : []

    content {
      publisher = try(
        var.instance.source_image_reference.publisher, var.source_image_reference != null ? var.source_image_reference.publisher : null
      )
      offer = try(
        var.instance.source_image_reference.offer, var.source_image_reference != null ? var.source_image_reference.offer : null
      )
      sku = try(
        var.instance.source_image_reference.sku, var.source_image_reference != null ? var.source_image_reference.sku : null
      )
      version = try(
        var.instance.source_image_reference.version, var.source_image_reference != null ? var.source_image_reference.version : null
      )
    }
  }

  dynamic "plan" {
    for_each = var.instance.plan != null ? [var.instance.plan] : []

    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  dynamic "identity" {
    for_each = lookup(var.instance, "identity", null) != null ? [var.instance.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

# interfaces
resource "azurerm_network_interface" "this" {
  for_each = {
    for interface_key, nic in lookup(var.instance, "interfaces", {}) :
    interface_key => nic
  }

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  name = coalesce(
    lookup(each.value, "name", null),
    lookup(var.naming, "network_interface", null) != null ? join("-", [var.naming.network_interface, var.instance.name, each.key]) : join("-", [var.instance.name, each.key])
  )

  ip_forwarding_enabled          = each.value.ip_forwarding_enabled
  accelerated_networking_enabled = each.value.accelerated_networking_enabled
  auxiliary_sku                  = each.value.auxiliary_sku
  auxiliary_mode                 = each.value.auxiliary_mode
  internal_dns_name_label        = each.value.internal_dns_name_label
  edge_zone                      = each.value.edge_zone
  dns_servers                    = each.value.dns_servers

  tags = coalesce(
    each.value.tags, var.tags
  )

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name = coalesce(
        ip_configuration.value.name, ip_configuration.key
      )

      private_ip_address_allocation                      = try(ip_configuration.value.private_ip_address, null) != null ? "Static" : "Dynamic"
      private_ip_address                                 = ip_configuration.value.private_ip_address
      public_ip_address_id                               = ip_configuration.value.public_ip_address_id
      subnet_id                                          = ip_configuration.value.subnet_id
      private_ip_address_version                         = ip_configuration.value.private_ip_address_version
      primary                                            = ip_configuration.value.primary
      gateway_load_balancer_frontend_ip_configuration_id = ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id
    }
  }
}

resource "azurerm_virtual_machine_extension" "this" {
  for_each = try(
    var.instance.extensions, {}
  )

  name                       = lookup(each.value, "name", null) != null ? each.value.name : element(split("-", each.key), length(split("-", each.key)) - 1)
  virtual_machine_id         = var.instance.type == "linux" ? azurerm_linux_virtual_machine.this["vm"].id : azurerm_windows_virtual_machine.this["vm"].id
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version
  settings                   = length(try(each.value.settings, {})) > 0 ? jsonencode(each.value.settings) : null
  protected_settings         = length(try(each.value.protected_settings, {})) > 0 ? jsonencode(each.value.protected_settings) : null

  provision_after_extensions  = each.value.provision_after_extensions
  failure_suppression_enabled = each.value.failure_suppression_enabled
  automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled

  dynamic "protected_settings_from_key_vault" {
    for_each = each.value.protected_settings_from_key_vault != null ? [each.value.protected_settings_from_key_vault] : []

    content {
      secret_url      = protected_settings_from_key_vault.value.secret_url
      source_vault_id = protected_settings_from_key_vault.value.source_vault_id
    }
  }

  tags = coalesce(
    each.value.tags, var.tags
  )
}

# data disks
resource "azurerm_managed_disk" "this" {
  for_each = try(
    var.instance.disks, {}
  )

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(
      var.instance, "location", null
    ), var.location
  )

  name = coalesce(
    lookup(each.value, "name", null),
    lookup(var.naming, "managed_disk", null) != null ? join("-", [var.naming.managed_disk, each.key]) : null
  )

  zone = try(
    coalesce(
      each.value.disk.zone, var.instance.zone
    ), null
  )

  storage_account_type              = each.value.storage_account_type
  create_option                     = each.value.create_option
  disk_size_gb                      = each.value.disk_size_gb
  tier                              = each.value.tier
  os_type                           = each.value.os_type
  edge_zone                         = each.value.edge_zone
  max_shares                        = each.value.max_shares
  source_uri                        = each.value.source_uri
  optimized_frequent_attach_enabled = each.value.optimized_frequent_attach_enabled
  public_network_access_enabled     = each.value.public_network_access_enabled
  on_demand_bursting_enabled        = each.value.on_demand_bursting_enabled
  gallery_image_reference_id        = each.value.gallery_image_reference_id
  performance_plus_enabled          = each.value.performance_plus_enabled
  trusted_launch_enabled            = each.value.trusted_launch_enabled
  network_access_policy             = each.value.network_access_policy
  logical_sector_size               = each.value.logical_sector_size
  source_resource_id                = each.value.source_resource_id
  image_reference_id                = each.value.image_reference_id
  secure_vm_disk_encryption_set_id  = each.value.secure_vm_disk_encryption_set_id
  disk_encryption_set_id            = each.value.disk_encryption_set_id
  security_type                     = each.value.security_type
  disk_access_id                    = each.value.disk_access_id
  hyper_v_generation                = each.value.hyper_v_generation
  storage_account_id                = each.value.storage_account_id
  disk_iops_read_write              = each.value.disk_iops_read_write
  disk_mbps_read_write              = each.value.disk_mbps_read_write
  upload_size_bytes                 = each.value.upload_size_bytes
  disk_iops_read_only               = each.value.disk_iops_read_only
  disk_mbps_read_only               = each.value.disk_mbps_read_only

  tags = coalesce(each.value.tags, var.tags)

  lifecycle {
    ignore_changes = [
      encryption_settings
    ]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = {
    for disk_key, disk in try(var.instance.disks, {}) : disk_key => disk
  }

  managed_disk_id           = azurerm_managed_disk.this[each.key].id
  virtual_machine_id        = var.instance.type == "linux" ? azurerm_linux_virtual_machine.this["vm"].id : azurerm_windows_virtual_machine.this["vm"].id
  lun                       = each.value.lun
  caching                   = each.value.caching
  write_accelerator_enabled = each.value.write_accelerator_enabled
  create_option             = each.value.create_option_disk_attachment
}
