data "azurerm_subscription" "current" {}

# linux vm
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.vm.type == "linux" ? { (var.vm.type) = true } : {}

  name                            = var.vm.name
  resource_group_name             = coalesce(lookup(var.vm, "resourcegroup", null), var.resourcegroup)
  location                        = coalesce(lookup(var.vm, "location", null), var.location)
  size                            = try(var.vm.size, "Standard_F2")
  admin_username                  = try(var.vm.username, "adminuser")
  license_type                    = try(var.vm.license_type, null)
  allow_extension_operations      = try(var.vm.allow_extension_operations, true)
  availability_set_id             = try(var.vm.availability_set, null)
  custom_data                     = try(var.vm.custom_data, null)
  user_data                       = try(var.vm.user_data, null)
  disable_password_authentication = try(var.vm.disable_password_authentication, true)
  encryption_at_host_enabled      = try(var.vm.encryption_at_host_enabled, false)
  extensions_time_budget          = try(var.vm.extensions_time_budget, null)
  patch_assessment_mode           = try(var.vm.patch_assessment_mode, "ImageDefault")
  patch_mode                      = try(var.vm.patch_mode, "ImageDefault")
  priority                        = try(var.vm.priority, "Regular")
  provision_vm_agent              = try(var.vm.provision_vm_agent, true)
  reboot_setting                  = try(var.vm.reboot_setting, null)
  secure_boot_enabled             = try(var.vm.secure_boot_enabled, null)
  vtpm_enabled                    = try(var.vm.vtpm_enabled, null)
  zone                            = try(var.vm.zone, null)

  additional_capabilities {
    ultra_ssd_enabled = try(var.vm.ultra_ssd_enabled, false)
  }

  boot_diagnostics {
    storage_account_uri = try(var.vm.boot_diags.storage_uri, null)
  }

  network_interface_ids = [
    for intf in local.interfaces :
    azurerm_network_interface.nic[intf.interface_key].id
  ]


  admin_ssh_key {
    username   = try(var.vm.username, "adminuser")
    public_key = azurerm_key_vault_secret.tls_public_key_secret[var.vm.type].value
  }

  os_disk {
    storage_account_type      = try(var.vm.os_disk.storage_account_type, "Standard_LRS")
    caching                   = try(var.vm.os_disk.caching, "ReadWrite")
    disk_size_gb              = try(var.vm.os_disk.disk_size_gb, null)
    security_encryption_type  = try(var.vm.os_disk.security_encryption_type, null)
    write_accelerator_enabled = try(var.vm.os_disk.write_accelerator_enabled, false)
  }

  source_image_reference {
    publisher = try(var.vm.image.publisher, "Canonical")
    offer     = try(var.vm.image.offer, "UbuntuServer")
    sku       = try(var.vm.image.sku, "18.04-LTS")
    version   = try(var.vm.image.version, "latest")
  }

  identity {
    type = "SystemAssigned"
  }
}

# secrets
resource "tls_private_key" "tls_key" {
  for_each = var.vm.type == "linux" ? { (var.vm.type) = true } : {}

  algorithm = try(var.vm.encryption.algorithm, "RSA")
  rsa_bits  = try(var.vm.encryption.rsa_bits, 4096)
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  for_each = var.vm.type == "linux" ? { (var.vm.type) = true } : {}

  name         = format("%s-%s-%s", "kvs", var.vm.name, "pub")
  value        = tls_private_key.tls_key[each.key].public_key_openssh
  key_vault_id = var.keyvault
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  for_each = var.vm.type == "linux" ? { (var.vm.type) = true } : {}

  name         = format("%s-%s-%s", "kvs", var.vm.name, "priv")
  value        = tls_private_key.tls_key[each.key].private_key_pem
  key_vault_id = var.keyvault
}

# windows vm
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.vm.type == "windows" ? { (var.vm.type) = true } : {}

  name                         = var.vm.name
  resource_group_name          = coalesce(lookup(var.vm, "resourcegroup", null), var.resourcegroup)
  location                     = coalesce(lookup(var.vm, "location", null), var.location)
  size                         = try(var.vm.size, "Standard_F2")
  admin_username               = try(var.vm.username, "adminuser")
  admin_password               = azurerm_key_vault_secret.secret[var.vm.type].value
  allow_extension_operations   = try(var.vm.allow_extension_operations, true)
  availability_set_id          = try(var.vm.availability_set, null)
  custom_data                  = try(var.vm.custom_data, null)
  user_data                    = try(var.vm.user_data, null)
  enable_automatic_updates     = try(var.vm.enable_automatic_updates, false)
  encryption_at_host_enabled   = try(var.vm.encryption_at_host_enabled, false)
  eviction_policy              = try(var.vm.eviction_policy, null)
  hotpatching_enabled          = try(var.vm.hotpatching_enabled, false)
  patch_assessment_mode        = try(var.vm.patch_assessment_mode, "ImageDefault")
  patch_mode                   = try(var.vm.patch_mode, "Manual")
  priority                     = try(var.vm.priority, "Regular")
  reboot_setting               = try(var.vm.reboot_setting, null)
  secure_boot_enabled          = try(var.vm.secure_boot_enabled, null)
  timezone                     = try(var.vm.timezone, null)
  virtual_machine_scale_set_id = try(var.vm.virtual_machine_scale_set_id, null)
  vtpm_enabled                 = try(var.vm.vtpm_enabled, null)
  zone                         = try(var.vm.zone, null)

  bypass_platform_safety_checks_on_user_schedule_enabled = try(var.vm.bypass_platform_safety_checks_on_user_schedule_enabled, false)

  network_interface_ids = [
    for intf in local.interfaces :
    azurerm_network_interface.nic[intf.interface_key].id
  ]

  additional_capabilities {
    ultra_ssd_enabled = try(var.vm.ultra_ssd_enabled, false)
  }

  boot_diagnostics {
    storage_account_uri = try(var.vm.boot_diags.storage_uri, null)
  }

  os_disk {
    storage_account_type             = try(var.vm.os_disk.storage_account_type, "Standard_LRS")
    caching                          = try(var.vm.os_disk.caching, "ReadWrite")
    disk_size_gb                     = try(var.vm.os_disk.disk_size_gb, null)
    write_accelerator_enabled        = try(var.vm.os_disk.write_accelerator_enabled, false)
    disk_encryption_set_id           = try(var.vm.os_disk.disk_encryption_set_id, null)
    security_encryption_type         = try(var.vm.os_disk.security_encryption_type, null)
    secure_vm_disk_encryption_set_id = try(var.vm.os_disk.secure_vm_disk_encryption_set_id, null)

  }

  source_image_reference {
    publisher = try(var.vm.image.publisher, "MicrosoftWindowsServer")
    offer     = try(var.vm.image.offer, "WindowsServer")
    sku       = try(var.vm.image.sku, "2022-datacenter-azure-edition")
    version   = try(var.vm.image.version, "latest")
  }
}

# random password
resource "random_password" "password" {
  for_each = var.vm.type == "windows" ? { (var.vm.type) = true } : {}

  length      = 24
  special     = true
  min_lower   = 5
  min_upper   = 7
  min_special = 4
  min_numeric = 5
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.vm.type == "windows" ? { (var.vm.type) = true } : {}

  name         = format("%s-%s", "kvs", var.vm.name)
  value        = random_password.password[each.key].result
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
  virtual_machine_id   = var.vm.type == "linux" ? azurerm_linux_virtual_machine.vm[var.vm.type].id : azurerm_windows_virtual_machine.vm[var.vm.type].id
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
  virtual_machine_id = var.vm.type == "linux" ? azurerm_linux_virtual_machine.vm[var.vm.type].id : azurerm_windows_virtual_machine.vm[var.vm.type].id
  lun                = each.value.lun
  caching            = each.value.caching
}
