# linux vm
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.instance.type == "linux" ? {
    (var.instance.name) = true
  } : {}

  name                              = var.instance.name
  computer_name                     = try(var.instance.computer_name, var.instance.name)
  resource_group_name               = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location                          = coalesce(lookup(var.instance, "location", null), var.location)
  size                              = try(var.instance.size, "Standard_D2s_v3")
  admin_username                    = try(var.instance.username, "adminuser")
  admin_password                    = try(var.instance.password, null) != null ? var.instance.password : null
  license_type                      = try(var.instance.license_type, null)
  allow_extension_operations        = try(var.instance.allow_extension_operations, true)
  availability_set_id               = try(var.instance.availability_set_id, null)
  custom_data                       = try(var.instance.custom_data, null)
  user_data                         = try(var.instance.user_data, null)
  capacity_reservation_group_id     = try(var.instance.capacity_reservation_group_id, null)
  virtual_machine_scale_set_id      = try(var.instance.virtual_machine_scale_set_id, null)
  proximity_placement_group_id      = try(var.instance.proximity_placement_group_id, null)
  dedicated_host_group_id           = try(var.instance.dedicated_host_group_id, null)
  platform_fault_domain             = try(var.instance.platform_fault_domain, null)
  source_image_id                   = try(var.instance.source_image_id, null)
  dedicated_host_id                 = try(var.instance.dedicated_host_id, null)
  max_bid_price                     = try(var.instance.max_bid_price, null)
  edge_zone                         = try(var.instance.edge_zone, null)
  disable_password_authentication   = try(var.instance.password, null) == null ? true : false
  encryption_at_host_enabled        = try(var.instance.encryption_at_host_enabled, false)
  extensions_time_budget            = try(var.instance.extensions_time_budget, null)
  patch_assessment_mode             = try(var.instance.patch_assessment_mode, "ImageDefault")
  patch_mode                        = try(var.instance.patch_mode, "ImageDefault")
  priority                          = try(var.instance.priority, "Regular")
  provision_vm_agent                = try(var.instance.provision_vm_agent, true)
  reboot_setting                    = try(var.instance.reboot_setting, null)
  secure_boot_enabled               = try(var.instance.secure_boot_enabled, false)
  vm_agent_platform_updates_enabled = try(var.instance.vm_agent_platform_updates_enabled, null)
  vtpm_enabled                      = try(var.instance.vtpm_enabled, false)
  zone                              = try(var.instance.zone, null)
  tags                              = try(var.instance.tags, var.tags, null)

  bypass_platform_safety_checks_on_user_schedule_enabled = try(var.instance.bypass_platform_safety_checks_on_user_schedule_enabled, false)

  dynamic "additional_capabilities" {
    for_each = try(var.instance.additional_capabilities, null) != null ? [1] : []

    content {
      ultra_ssd_enabled   = try(var.instance.additional_capabilities.ultra_ssd_enabled, false)
      hibernation_enabled = try(var.instance.additional_capabilities.hibernation_enabled, false)
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.instance, "boot_diagnostics", null) != null ? [1] : []
    content {
      storage_account_uri = lookup(var.instance.boot_diagnostics, "storage_account_uri", null)
    }
  }

  network_interface_ids = [
    for intf in local.interfaces :
    azurerm_network_interface.nic[intf.interface_key].id
  ]

  dynamic "admin_ssh_key" {
    for_each = try(var.instance.public_key, null) != null || try(var.instance.password, null) == null && try(var.instance.public_key, null) == null ? [1] : []
    content {
      username   = try(var.instance.username, "adminuser")
      public_key = try(var.instance.public_key, null) != null ? var.instance.public_key : tls_private_key.tls_key[var.instance.name].public_key_openssh
    }
  }

  os_disk {
    name                      = try(var.instance.os_disk.name, null)
    storage_account_type      = try(var.instance.os_disk.storage_account_type, "Standard_LRS")
    caching                   = try(var.instance.os_disk.caching, "ReadWrite")
    disk_size_gb              = try(var.instance.os_disk.disk_size_gb, null)
    security_encryption_type  = try(var.instance.os_disk.security_encryption_type, null)
    write_accelerator_enabled = try(var.instance.os_disk.write_accelerator_enabled, false)
  }

  dynamic "source_image_reference" {
    for_each = try(var.instance.source_image_id, null) == null ? [true] : []
    content {
      publisher = try(var.instance.source_image_reference.publisher, "Canonical")
      offer     = try(var.instance.source_image_reference.offer, "UbuntuServer")
      sku       = try(var.instance.source_image_reference.sku, "18.04-LTS")
      version   = try(var.instance.source_image_reference.version, "latest")
    }
  }

  dynamic "plan" {
    for_each = try(var.instance.plan, null) != null ? [1] : []

    content {
      name      = try(var.instance.plan.name, null)
      product   = try(var.instance.plan.product, null)
      publisher = try(var.instance.plan.publisher, null)
    }
  }

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity[var.instance.name].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }
}

# secrets
resource "tls_private_key" "tls_key" {
  for_each = var.instance.type == "linux" && contains(keys(var.instance), "public_key") == false && contains(keys(
  var.instance), "password") == false ? { (var.instance.name) = true } : {}

  algorithm = try(var.instance.encryption.algorithm, "RSA")
  rsa_bits  = try(var.instance.encryption.rsa_bits, 4096)
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.instance.type == "linux" && contains(keys(var.instance), "public_key") == false && contains(keys(
  var.instance), "password") == false ? { (var.instance.name) = true } : {}

  name         = format("%s-%s-%s", "kvs", var.instance.name, "pub")
  value        = tls_private_key.tls_key[var.instance.name].public_key_openssh
  key_vault_id = var.keyvault
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.instance.type == "linux" && contains(keys(var.instance), "public_key") == false && contains(keys(
  var.instance), "password") == false ? { (var.instance.name) = true } : {}

  name         = format("%s-%s-%s", "kvs", var.instance.name, "priv")
  value        = tls_private_key.tls_key[var.instance.name].private_key_pem
  key_vault_id = var.keyvault
}

# windows vm
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.instance.type == "windows" ? {
    (var.instance.name) = true
  } : {}

  name                = var.instance.name
  computer_name       = try(var.instance.computer_name, var.instance.name)
  resource_group_name = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.instance, "location", null), var.location)
  size                = try(var.instance.size, "Standard_D2s_v3")
  admin_username      = try(var.instance.username, "adminuser")

  admin_password = length(lookup(var.instance, "password", {})) > 0 ? var.instance.password : azurerm_key_vault_secret.secret[var.instance.name].value

  allow_extension_operations        = try(var.instance.allow_extension_operations, true)
  availability_set_id               = try(var.instance.availability_set_id, null)
  custom_data                       = try(var.instance.custom_data, null)
  user_data                         = try(var.instance.user_data, null)
  enable_automatic_updates          = try(var.instance.enable_automatic_updates, true)
  encryption_at_host_enabled        = try(var.instance.encryption_at_host_enabled, false)
  eviction_policy                   = try(var.instance.eviction_policy, null)
  hotpatching_enabled               = try(var.instance.hotpatching_enabled, false)
  patch_assessment_mode             = try(var.instance.patch_assessment_mode, "ImageDefault")
  patch_mode                        = try(var.instance.patch_mode, "AutomaticByOS")
  priority                          = try(var.instance.priority, "Regular")
  reboot_setting                    = try(var.instance.reboot_setting, null)
  secure_boot_enabled               = try(var.instance.secure_boot_enabled, false)
  license_type                      = try(var.instance.license_type, null)
  max_bid_price                     = try(var.instance.max_bid_price, null)
  edge_zone                         = try(var.instance.edge_zone, null)
  dedicated_host_id                 = try(var.instance.dedicated_host_id, null)
  source_image_id                   = try(var.instance.source_image_id, null)
  platform_fault_domain             = try(var.instance.platform_fault_domain, null)
  extensions_time_budget            = try(var.instance.extensions_time_budget, null)
  dedicated_host_group_id           = try(var.instance.dedicated_host_group_id, null)
  proximity_placement_group_id      = try(var.instance.proximity_placement_group_id, null)
  capacity_reservation_group_id     = try(var.instance.capacity_reservation_group_id, null)
  timezone                          = try(var.instance.timezone, null)
  virtual_machine_scale_set_id      = try(var.instance.virtual_machine_scale_set_id, null)
  vm_agent_platform_updates_enabled = try(var.instance.vm_agent_platform_updates_enabled, null)
  vtpm_enabled                      = try(var.instance.vtpm_enabled, false)
  zone                              = try(var.instance.zone, null)
  tags                              = try(var.instance.tags, var.tags, null)

  bypass_platform_safety_checks_on_user_schedule_enabled = try(var.instance.bypass_platform_safety_checks_on_user_schedule_enabled, false)

  network_interface_ids = [
    for intf in local.interfaces :
    azurerm_network_interface.nic[intf.interface_key].id
  ]

  dynamic "additional_capabilities" {
    for_each = try(var.instance.additional_capabilities, null) != null ? [1] : []

    content {
      ultra_ssd_enabled   = try(var.instance.additional_capabilities.ultra_ssd_enabled, false)
      hibernation_enabled = try(var.instance.additional_capabilities.hibernation_enabled, false)
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(var.instance, "boot_diagnostics", null) != null ? [1] : []
    content {
      storage_account_uri = lookup(var.instance.boot_diagnostics, "storage_account_uri", null)
    }
  }

  os_disk {
    storage_account_type             = try(var.instance.os_disk.storage_account_type, "StandardSSD_LRS")
    caching                          = try(var.instance.os_disk.caching, "ReadWrite")
    disk_size_gb                     = try(var.instance.os_disk.disk_size_gb, null)
    write_accelerator_enabled        = try(var.instance.os_disk.write_accelerator_enabled, false)
    disk_encryption_set_id           = try(var.instance.os_disk.disk_encryption_set_id, null)
    security_encryption_type         = try(var.instance.os_disk.security_encryption_type, null)
    secure_vm_disk_encryption_set_id = try(var.instance.os_disk.secure_vm_disk_encryption_set_id, null)
    name                             = try(var.instance.os_disk.name, null)
  }

  dynamic "source_image_reference" {
    for_each = try(var.instance.source_image_id, null) == null ? [true] : []

    content {
      publisher = try(var.instance.source_image_reference.publisher, "MicrosoftWindowsServer")
      offer     = try(var.instance.source_image_reference.offer, "WindowsServer")
      sku       = try(var.instance.source_image_reference.sku, "2022-Datacenter")
      version   = try(var.instance.source_image_reference.version, "latest")
    }
  }

  dynamic "plan" {
    for_each = try(var.instance.plan, null) != null ? [1] : []

    content {
      name      = try(var.instance.plan.name, null)
      product   = try(var.instance.plan.product, null)
      publisher = try(var.instance.plan.publisher, null)
    }
  }

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity[var.instance.name].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }
}

resource "random_password" "password" {
  for_each = var.instance.type == "windows" && contains(keys(var.instance), "password") == false ? { (var.instance.name) = true } : {}

  length      = 24
  special     = true
  min_lower   = 5
  min_upper   = 7
  min_special = 4
  min_numeric = 5
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.instance.type == "windows" && contains(keys(var.instance), "password") == false ? { (var.instance.name) = true } : {}

  name         = format("%s-%s", "kvs", var.instance.name)
  value        = random_password.password[var.instance.name].result
  key_vault_id = var.keyvault
}

# interfaces
resource "azurerm_network_interface" "nic" {
  for_each = {
    for intf in local.interfaces : intf.interface_key => intf
  }

  name                           = each.value.name
  resource_group_name            = each.value.resource_group
  location                       = each.value.location
  ip_forwarding_enabled          = each.value.ip_forwarding_enabled
  accelerated_networking_enabled = each.value.accelerated_networking_enabled
  auxiliary_sku                  = each.value.auxiliary_sku
  auxiliary_mode                 = each.value.auxiliary_mode
  internal_dns_name_label        = each.value.internal_dns_name_label
  edge_zone                      = each.value.edge_zone
  dns_servers                    = each.value.dns_servers
  tags                           = each.value.tags

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name                          = ip_configuration.value.name
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = ip_configuration.value.public_ip_address_id
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_version    = ip_configuration.value.private_ip_address_version
      primary                       = ip_configuration.value.primary
    }
  }
}

resource "azurerm_virtual_machine_extension" "ext" {
  for_each = local.ext_keys

  name                       = each.value.name
  virtual_machine_id         = var.instance.type == "linux" ? azurerm_linux_virtual_machine.vm[each.value.vm_name].id : azurerm_windows_virtual_machine.vm[each.value.vm_name].id
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version
  settings                   = each.value.settings
  protected_settings         = each.value.protected_settings
  tags                       = each.value.tags

}

# data disks
resource "azurerm_managed_disk" "disks" {
  for_each = {
    for disk in local.data_disks : "${disk.vm_name}-${disk.disk_key}" => disk
  }

  name                              = each.value.name
  location                          = each.value.location
  resource_group_name               = each.value.resource_group
  storage_account_type              = each.value.storage_account_type
  create_option                     = each.value.create_option
  disk_size_gb                      = each.value.disk_size_gb
  tier                              = each.value.tier
  zone                              = each.value.zone
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
  tags                              = each.value.tags

  lifecycle {
    ignore_changes = [
      encryption_settings
    ]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "at" {
  for_each = { for disk in local.data_disks : "${disk.vm_name}-${disk.disk_key}" => disk }

  managed_disk_id    = azurerm_managed_disk.disks[each.key].id
  virtual_machine_id = var.instance.type == "linux" ? azurerm_linux_virtual_machine.vm[var.instance.name].id : azurerm_windows_virtual_machine.vm[var.instance.name].id
  lun                = each.value.lun
  caching            = each.value.caching
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(
    ["UserAssigned", "SystemAssigned, UserAssigned"], try(var.instance.identity.type, "")
  ) ? { (var.instance.name) = {} } : {}


  name                = try(var.instance.identity.name, "uai-${var.instance.name}")
  resource_group_name = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.instance, "location", null), var.location)
  tags                = try(var.instance.identity.tags, var.tags, null)
}
