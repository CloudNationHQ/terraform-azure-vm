data "azurerm_subscription" "current" {}

# linux vm
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.instance.type == "linux" ? {
    (var.instance.type) = true
  } : {}

  name                            = var.instance.name
  computer_name                   = try(var.instance.computer_name, null)
  resource_group_name             = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
  location                        = coalesce(lookup(var.instance, "location", null), var.location)
  size                            = try(var.instance.size, "Standard_D2s_v3")
  admin_username                  = try(var.instance.username, "adminuser")
  license_type                    = try(var.instance.license_type, null)
  allow_extension_operations      = try(var.instance.allow_extension_operations, true)
  availability_set_id             = try(var.instance.availability_set, null)
  custom_data                     = try(var.instance.custom_data, null)
  user_data                       = try(var.instance.user_data, null)
  disable_password_authentication = try(var.instance.disable_password_authentication, true)
  encryption_at_host_enabled      = try(var.instance.encryption_at_host_enabled, false)
  extensions_time_budget          = try(var.instance.extensions_time_budget, null)
  patch_assessment_mode           = try(var.instance.patch_assessment_mode, "ImageDefault")
  patch_mode                      = try(var.instance.patch_mode, "ImageDefault")
  priority                        = try(var.instance.priority, "Regular")
  provision_vm_agent              = try(var.instance.provision_vm_agent, true)
  reboot_setting                  = try(var.instance.reboot_setting, null)
  secure_boot_enabled             = try(var.instance.secure_boot_enabled, null)
  vtpm_enabled                    = try(var.instance.vtpm_enabled, null)
  zone                            = try(var.instance.zone, null)

  additional_capabilities {
    ultra_ssd_enabled = try(var.instance.ultra_ssd_enabled, false)
  }

  boot_diagnostics {
    storage_account_uri = try(var.instance.boot_diags.storage_uri, null)
  }

  network_interface_ids = [
    for intf in local.interfaces :
    azurerm_network_interface.nic[intf.interface_key].id
  ]

  admin_ssh_key {
    username   = try(var.instance.username, "adminuser")
    public_key = length(lookup(var.instance, "secrets", {})) == 0 ? tls_private_key.tls_key["generate"].public_key_openssh : var.instance.secrets.public_key
  }

  os_disk {
    storage_account_type      = try(var.instance.os_disk.storage_account_type, "Standard_LRS")
    caching                   = try(var.instance.os_disk.caching, "ReadWrite")
    disk_size_gb              = try(var.instance.os_disk.disk_size_gb, null)
    security_encryption_type  = try(var.instance.os_disk.security_encryption_type, null)
    write_accelerator_enabled = try(var.instance.os_disk.write_accelerator_enabled, false)
  }

  source_image_reference {
    publisher = try(var.instance.image.publisher, "Canonical")
    offer     = try(var.instance.image.offer, "UbuntuServer")
    sku       = try(var.instance.image.sku, "18.04-LTS")
    version   = try(var.instance.image.version, "latest")
  }

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }
}

# secrets
resource "tls_private_key" "tls_key" {
  # workaround, keys used in for each must be known at plan time
  for_each = var.instance.type == "linux" && lookup(
    var.instance, "secrets", {}) == {} ? {
    "generate" = true
  } : {}

  algorithm = try(var.instance.encryption.algorithm, "RSA")
  rsa_bits  = try(var.instance.encryption.rsa_bits, 4096)
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.instance.type == "linux" && lookup(
    var.instance, "secrets", {}) == {} ? {
    "generate" = true
  } : {}

  name         = format("%s-%s-%s", "kvs", var.instance.name, "pub")
  value        = tls_private_key.tls_key[each.key].public_key_openssh
  key_vault_id = var.keyvault
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.instance.type == "linux" && lookup(
    var.instance, "secrets", {}) == {} ? {
    "generate" = true
  } : {}

  name         = format("%s-%s-%s", "kvs", var.instance.name, "priv")
  value        = tls_private_key.tls_key[each.key].private_key_pem
  key_vault_id = var.keyvault
}

# windows vm
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.instance.type == "windows" ? {
    (var.instance.type) = true
  } : {}

  name                = var.instance.name
  computer_name       = try(var.instance.computer_name, null)
  resource_group_name = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
  location            = coalesce(lookup(var.instance, "location", null), var.location)
  size                = try(var.instance.size, "Standard_D2s_v3")
  admin_username      = try(var.instance.username, "adminuser")

  admin_password = length(
    lookup(var.instance, "secrets", {})) > 0 ? var.instance.secrets.password : (
    var.instance.type == "windows" ? azurerm_key_vault_secret.secret["generate"].value : ""
  )

  allow_extension_operations   = try(var.instance.allow_extension_operations, true)
  availability_set_id          = try(var.instance.availability_set, null)
  custom_data                  = try(var.instance.custom_data, null)
  user_data                    = try(var.instance.user_data, null)
  enable_automatic_updates     = try(var.instance.enable_automatic_updates, false)
  encryption_at_host_enabled   = try(var.instance.encryption_at_host_enabled, false)
  eviction_policy              = try(var.instance.eviction_policy, null)
  hotpatching_enabled          = try(var.instance.hotpatching_enabled, false)
  patch_assessment_mode        = try(var.instance.patch_assessment_mode, "ImageDefault")
  patch_mode                   = try(var.instance.patch_mode, "Manual")
  priority                     = try(var.instance.priority, "Regular")
  reboot_setting               = try(var.instance.reboot_setting, null)
  secure_boot_enabled          = try(var.instance.secure_boot_enabled, null)
  timezone                     = try(var.instance.timezone, null)
  virtual_machine_scale_set_id = try(var.instance.virtual_machine_scale_set_id, null)
  vtpm_enabled                 = try(var.instance.vtpm_enabled, null)
  zone                         = try(var.instance.zone, null)

  bypass_platform_safety_checks_on_user_schedule_enabled = try(var.instance.bypass_platform_safety_checks_on_user_schedule_enabled, false)

  network_interface_ids = [
    for intf in local.interfaces :
    azurerm_network_interface.nic[intf.interface_key].id
  ]

  additional_capabilities {
    ultra_ssd_enabled = try(var.instance.ultra_ssd_enabled, false)
  }

  boot_diagnostics {
    storage_account_uri = try(var.instance.boot_diags.storage_uri, null)
  }

  os_disk {
    storage_account_type             = try(var.instance.os_disk.storage_account_type, "Standard_LRS")
    caching                          = try(var.instance.os_disk.caching, "ReadWrite")
    disk_size_gb                     = try(var.instance.os_disk.disk_size_gb, null)
    write_accelerator_enabled        = try(var.instance.os_disk.write_accelerator_enabled, false)
    disk_encryption_set_id           = try(var.instance.os_disk.disk_encryption_set_id, null)
    security_encryption_type         = try(var.instance.os_disk.security_encryption_type, null)
    secure_vm_disk_encryption_set_id = try(var.instance.os_disk.secure_vm_disk_encryption_set_id, null)
  }

  source_image_reference {
    publisher = try(var.instance.image.publisher, "MicrosoftWindowsServer")
    offer     = try(var.instance.image.offer, "WindowsServer")
    sku       = try(var.instance.image.sku, "2022-datacenter-azure-edition")
    version   = try(var.instance.image.version, "latest")
  }

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }
}

resource "random_password" "password" {
  # workaround, keys used in for each must be known at plan time
  for_each = var.instance.type == "windows" && lookup(
    var.instance, "secrets", {}) == {} ? {
    "generate" = true
  } : {}

  length      = 24
  special     = true
  min_lower   = 5
  min_upper   = 7
  min_special = 4
  min_numeric = 5
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.instance.type == "windows" && lookup(
    var.instance, "secrets", {}) == {} ? {
    "generate" = true
  } : {}

  name         = format("%s-%s", "kvs", var.instance.name)
  value        = random_password.password["generate"].result
  key_vault_id = var.keyvault
}

# interfaces
resource "azurerm_network_interface" "nic" {
  for_each = {
    for nic in local.interfaces : nic.interface_key => nic
  }

  name                          = each.value.name
  resource_group_name           = each.value.resourcegroup
  location                      = each.value.location
  enable_accelerated_networking = each.value.enable_accelerated_networking
  enable_ip_forwarding          = each.value.enable_ip_forwarding
  dns_servers                   = each.value.dns_servers

  ip_configuration {
    name                          = "ipconfig"
    private_ip_address_allocation = each.value.private_ip_address_allocation
    private_ip_address            = each.value.private_ip_address
    public_ip_address_id          = each.value.public_ip_address_id
    subnet_id                     = each.value.subnet_id
  }
}

# extensions
resource "azurerm_virtual_machine_extension" "ext" {
  for_each = {
    for ext in local.ext_keys : ext.ext_key => ext
  }

  name                 = each.value.name
  virtual_machine_id   = var.instance.type == "linux" ? azurerm_linux_virtual_machine.vm[var.instance.type].id : azurerm_windows_virtual_machine.vm[var.instance.type].id
  publisher            = each.value.publisher
  type                 = each.value.type
  type_handler_version = each.value.type_handler_version
  settings             = try(jsonencode(each.value.settings), null)
  protected_settings   = try(jsonencode(each.value.protected_settings), null)
}

# data disks
resource "azurerm_managed_disk" "disks" {
  for_each = {
    for disk in local.data_disks : disk.disk_key => disk
  }

  name                 = each.value.name
  location             = each.value.location
  resource_group_name  = each.value.resourcegroup
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "at" {
  for_each = {
    for disk in local.data_disks : disk.disk_key => disk
  }

  managed_disk_id    = azurerm_managed_disk.disks[each.key].id
  virtual_machine_id = var.instance.type == "linux" ? azurerm_linux_virtual_machine.vm[var.instance.type].id : azurerm_windows_virtual_machine.vm[var.instance.type].id
  lun                = each.value.lun
  caching            = each.value.caching
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(
    ["UserAssigned", "SystemAssigned, UserAssigned"], try(var.instance.identity.type, "")
  ) ? { "identity" = {} } : {}

  location            = var.instance.location
  name                = var.naming.user_assigned_identity
  resource_group_name = var.instance.resourcegroup
}
