# linux vm
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.instance.type == "linux" ? {
    (var.instance.name) = true
  } : {}

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group", null
    ), var.resource_group
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
  zone                          = var.instance.zone

  disable_password_authentication = (
    try(var.instance.password, null) != null ? false : try(var.instance.public_key, null) != null ||
    contains(keys(tls_private_key.tls_key), var.instance.name) ? true : try(var.instance.disable_password_authentication, true)
  )

  tags = try(
    var.instance.tags, var.tags, null
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
    for_each = try(var.instance.termination_notification, null) != null ? [1] : []

    content {
      enabled = var.instance.termination_notification.enabled
      timeout = var.instance.termination_notification.timeout
    }
  }

  dynamic "os_image_notification" {
    for_each = try(var.instance.os_image_notification, null) != null ? [1] : []

    content {
      timeout = var.instance.os_image_notification.timeout
    }
  }


  dynamic "additional_capabilities" {
    for_each = try(var.instance.additional_capabilities, null) != null ? [1] : []

    content {
      ultra_ssd_enabled   = var.instance.additional_capabilities.ultra_ssd_enabled
      hibernation_enabled = var.instance.additional_capabilities.hibernation_enabled
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.instance, "boot_diagnostics", null) != null ? [1] : []

    content {
      storage_account_uri = lookup(
        var.instance.boot_diagnostics, "storage_account_uri", null
      )
    }
  }

  network_interface_ids = [
    for interface_key, nic in var.instance.interfaces :
    azurerm_network_interface.nic["${var.instance.name}-${interface_key}"].id
  ]

  dynamic "admin_ssh_key" {
    for_each = try(var.instance.public_key, null) != null || contains(keys(tls_private_key.tls_key), var.instance.name) ? [1] : []

    content {
      username   = var.instance.username
      public_key = try(var.instance.public_key, null) != null ? var.instance.public_key : tls_private_key.tls_key[var.instance.name].public_key_openssh
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
      for_each = try(var.instance.os_disk.diff_disk_settings, null) != null ? [1] : []

      content {
        option    = var.instance.os_disk.diff_disk_settings.option
        placement = var.instance.os_disk.diff_disk_settings.placement
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
    for_each = try(var.instance.plan, null) != null ? [1] : []

    content {
      name      = var.instance.plan.name
      product   = var.instance.plan.product
      publisher = var.instance.plan.publisher
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

# secrets
resource "tls_private_key" "tls_key" {
  for_each = var.instance.type == "linux" && try(var.instance.generate_ssh_key.enable, false) == true ? { (var.instance.name) = true } : {}

  algorithm   = var.instance.generate_ssh_key.algorithm
  rsa_bits    = var.instance.generate_ssh_key.rsa_bits
  ecdsa_curve = var.instance.generate_ssh_key.ecdsa_curve
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.instance.type == "linux" && try(var.instance.generate_ssh_key.enable, false) == true ? { (var.instance.name) = true } : {}

  name             = format("%s-%s-%s", "kvs", var.instance.name, "pub")
  value            = tls_private_key.tls_key[var.instance.name].public_key_openssh
  key_vault_id     = var.keyvault
  expiration_date  = var.instance.generate_ssh_key.expiration_date
  not_before_date  = var.instance.generate_ssh_key.not_before_date
  value_wo_version = var.instance.generate_ssh_key.value_wo_version
  value_wo         = var.instance.generate_ssh_key.value_wo
  content_type     = var.instance.generate_ssh_key.content_type

  tags = try(
    var.instance.tags, var.tags, null
  )
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.instance.type == "linux" && try(var.instance.generate_ssh_key.enable, false) == true ? { (var.instance.name) = true } : {}

  name             = format("%s-%s-%s", "kvs", var.instance.name, "priv")
  value            = tls_private_key.tls_key[var.instance.name].private_key_pem
  key_vault_id     = var.keyvault
  expiration_date  = var.instance.generate_ssh_key.expiration_date
  not_before_date  = var.instance.generate_ssh_key.not_before_date
  value_wo         = var.instance.generate_ssh_key.value_wo
  value_wo_version = var.instance.generate_ssh_key.value_wo_version
  content_type     = var.instance.generate_ssh_key.content_type

  tags = try(
    var.instance.tags, var.tags, null
  )
}

# windows vm
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.instance.type == "windows" ? {
    (var.instance.name) = true
  } : {}

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group", null
    ), var.resource_group
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
  admin_password                = try(var.instance.password, null) != null ? var.instance.password : (contains(keys(random_password.password), var.instance.name) ? random_password.password[var.instance.name].result : null)
  allow_extension_operations    = var.instance.allow_extension_operations
  availability_set_id           = var.instance.availability_set_id
  custom_data                   = var.instance.custom_data
  user_data                     = var.instance.user_data
  enable_automatic_updates      = var.instance.enable_automatic_updates
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

  # diffent defaults for windows and linux
  patch_mode = try(
    var.instance.patch_mode, "AutomaticByOS"
  )

  tags = try(
    var.instance.tags, var.tags, null
  )

  bypass_platform_safety_checks_on_user_schedule_enabled = var.instance.bypass_platform_safety_checks_on_user_schedule_enabled

  network_interface_ids = [
    for interface_key, nic in var.instance.interfaces :
    azurerm_network_interface.nic["${var.instance.name}-${interface_key}"].id
  ]

  dynamic "winrm_listener" {
    for_each = try(
      var.instance.winrm_listeners, {}
    )

    content {
      protocol        = winrm.listener.value.protocol
      certificate_url = winrm.listener.value.certificate_url
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
    for_each = try(var.instance.os_image_notification, null) != null ? [1] : []

    content {
      timeout = var.instance.os_image_notification.timeout
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
    for_each = try(var.instance.termination_notification, null) != null ? [1] : []

    content {
      enabled = var.instance.termination_notification.enabled
      timeout = var.instance.termination_notification.timeout
    }
  }

  dynamic "additional_capabilities" {
    for_each = try(var.instance.additional_capabilities, null) != null ? [1] : []

    content {
      ultra_ssd_enabled   = var.instance.additional_capabilities.ultra_ssd_enabled
      hibernation_enabled = var.instance.additional_capabilities.hibernation_enabled
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.instance, "boot_diagnostics", null) != null ? [1] : []

    content {
      storage_account_uri = var.instance.boot_diagnostics.storage_account_uri
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
      for_each = try(var.instance.os_disk.diff_disk_settings, null) != null ? [1] : []

      content {
        option    = var.instance.os_disk.diff_disk_settings.option
        placement = var.instance.os_disk.diff_disk_settings.placement
      }
    }
  }

  dynamic "additional_unattend_content" {
    for_each = try(var.instance.addtional_unattend_contents, {})

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
    for_each = try(var.instance.plan, null) != null ? [1] : []

    content {
      name      = var.instance.plan.name
      product   = var.instance.plan.product
      publisher = var.instance.plan.publisher
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

resource "random_password" "password" {
  for_each = var.instance.type == "windows" && try(var.instance.generate_password.enable, false) == true ? { (var.instance.name) = true } : {}

  length           = var.instance.generate_password.length
  special          = var.instance.generate_password.special
  min_lower        = var.instance.generate_password.min_lower
  min_upper        = var.instance.generate_password.min_upper
  min_special      = var.instance.generate_password.min_special
  min_numeric      = var.instance.generate_password.min_numeric
  numeric          = var.instance.generate_password.numeric
  upper            = var.instance.generate_password.upper
  lower            = var.instance.generate_password.lower
  override_special = var.instance.generate_password.override_special
  keepers          = var.instance.generate_password.keepers
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.instance.type == "windows" && try(var.instance.generate_password.enable, false) == true ? { (var.instance.name) = true } : {}

  name             = format("%s-%s", "kvs", var.instance.name)
  value            = random_password.password[var.instance.name].result
  key_vault_id     = var.keyvault
  value_wo_version = var.instance.generate_password.value_wo_version
  value_wo         = var.instance.generate_password.value_wo
  content_type     = var.instance.generate_password.content_type
  not_before_date  = var.instance.generate_password.not_before_date
  expiration_date  = var.instance.generate_password.expiration_date

  tags = try(
    var.instance.tags, var.tags, null
  )
}

# interfaces
resource "azurerm_network_interface" "nic" {
  for_each = {
    for interface_key, nic in var.instance.interfaces : "${var.instance.name}-${interface_key}" => {
      interface_key = interface_key
      nic           = nic
    }
  }

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group", null
    ), var.resource_group
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.nic.name, join("-", [var.naming.network_interface, var.instance.name, each.value.interface_key])
  )

  ip_forwarding_enabled          = each.value.nic.ip_forwarding_enabled
  accelerated_networking_enabled = each.value.nic.accelerated_networking_enabled
  auxiliary_sku                  = each.value.nic.auxiliary_sku
  auxiliary_mode                 = each.value.nic.auxiliary_mode
  internal_dns_name_label        = each.value.nic.internal_dns_name_label
  edge_zone                      = each.value.nic.edge_zone
  dns_servers                    = each.value.nic.dns_servers

  tags = try(
    each.value.nic.tags, var.tags, null
  )

  dynamic "ip_configuration" {
    for_each = each.value.nic.ip_configurations

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

resource "azurerm_virtual_machine_extension" "ext" {
  for_each = length(lookup(var.instance, "extensions", {})) > 0 ? {
    for ext_key, ext in lookup(var.instance, "extensions", {}) :
    "${var.instance.name}-${ext_key}" => ext
  } : {}

  name = coalesce(
    each.value.name, element(split("-", each.key), 1)
  )

  virtual_machine_id          = var.instance.type == "linux" ? azurerm_linux_virtual_machine.vm[var.instance.name].id : azurerm_windows_virtual_machine.vm[var.instance.name].id
  publisher                   = each.value.publisher
  type                        = each.value.type
  type_handler_version        = each.value.type_handler_version
  auto_upgrade_minor_version  = each.value.auto_upgrade_minor_version
  settings                    = try(each.value.settings, null) != null ? jsonencode(each.value.settings) : null
  protected_settings          = try(each.value.protected_settings, null) != null ? jsonencode(each.value.protected_settings) : null
  provision_after_extensions  = each.value.provision_after_extensions
  failure_suppression_enabled = each.value.failure_suppression_enabled
  automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled

  dynamic "protected_settings_from_key_vault" {
    for_each = try(each.value.protected_settings_from_key_vault, null) != null ? [1] : []

    content {
      secret_url      = protected_settings_from_key_vault.value.secret_url
      source_vault_id = protected_settings_from_key_vault.value.source_vault_id
    }
  }

  tags = try(
    each.value.tags, var.tags, null
  )
}

# data disks
resource "azurerm_managed_disk" "disks" {
  for_each = {
    for disk_key, disk in try(var.instance.disks, {}) : "${var.instance.name}-${disk_key}" => {
      disk_key = disk_key
      disk     = disk
    }
  }

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group", null
    ), var.resource_group
  )

  location = coalesce(
    lookup(
      var.instance, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.disk.name, join("-", [var.naming.managed_disk, each.value.disk_key])
  )

  storage_account_type              = each.value.disk.storage_account_type
  create_option                     = each.value.disk.create_option
  disk_size_gb                      = each.value.disk.disk_size_gb
  tier                              = each.value.disk.tier
  zone                              = each.value.disk.zone
  os_type                           = each.value.disk.os_type
  edge_zone                         = each.value.disk.edge_zone
  max_shares                        = each.value.disk.max_shares
  source_uri                        = each.value.disk.source_uri
  optimized_frequent_attach_enabled = each.value.disk.optimized_frequent_attach_enabled
  public_network_access_enabled     = each.value.disk.public_network_access_enabled
  on_demand_bursting_enabled        = each.value.disk.on_demand_bursting_enabled
  gallery_image_reference_id        = each.value.disk.gallery_image_reference_id
  performance_plus_enabled          = each.value.disk.performance_plus_enabled
  trusted_launch_enabled            = each.value.disk.trusted_launch_enabled
  network_access_policy             = each.value.disk.network_access_policy
  logical_sector_size               = each.value.disk.logical_sector_size
  source_resource_id                = each.value.disk.source_resource_id
  image_reference_id                = each.value.disk.image_reference_id
  secure_vm_disk_encryption_set_id  = each.value.disk.secure_vm_disk_encryption_set_id
  disk_encryption_set_id            = each.value.disk.disk_encryption_set_id
  security_type                     = each.value.disk.security_type
  disk_access_id                    = each.value.disk.disk_access_id
  hyper_v_generation                = each.value.disk.hyper_v_generation
  storage_account_id                = each.value.disk.storage_account_id
  disk_iops_read_write              = each.value.disk.disk_iops_read_write
  disk_mbps_read_write              = each.value.disk.disk_mbps_read_write
  upload_size_bytes                 = each.value.disk.upload_size_bytes
  disk_iops_read_only               = each.value.disk.disk_iops_read_only
  disk_mbps_read_only               = each.value.disk.disk_mbps_read_only

  tags = try(
    each.value.disk.tags, var.tags, null
  )

  lifecycle {
    ignore_changes = [
      encryption_settings
    ]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "at" {
  for_each = {
    for disk_key, disk in try(var.instance.disks, {}) : "${var.instance.name}-${disk_key}" => disk
  }

  managed_disk_id           = azurerm_managed_disk.disks[each.key].id
  virtual_machine_id        = var.instance.type == "linux" ? azurerm_linux_virtual_machine.vm[var.instance.name].id : azurerm_windows_virtual_machine.vm[var.instance.name].id
  lun                       = each.value.lun
  caching                   = each.value.caching
  write_accelerator_enabled = each.value.write_accelerator_enabled
  create_option             = each.value.create_option_disk_attachment
}
