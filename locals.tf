locals {
  interfaces = [
    for interface_key, nic in var.instance.interfaces : {
      vm_name                       = var.instance.name
      interface_key                 = interface_key
      name                          = try(nic.name, join("-", [var.naming.network_interface, interface_key]))
      dns_servers                   = try(nic.dns_servers, [])
      enable_accelerated_networking = try(nic.enable_accelerated_networking, false)
      enable_ip_forwarding          = try(nic.enable_ip_forwarding, false)
      subnet_id                     = nic.subnet
      ip_config_name                = try(nic.ip_config_name, "ipconfig")
      private_ip_address_allocation = try(nic.private_ip_address_allocation, "Dynamic")
      private_ip_address            = try(nic.private_ip_address, null)
      public_ip_address_id          = try(nic.public_ip_address_id, null)
      resourcegroup                 = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
      location                      = coalesce(lookup(var.instance, "location", null), var.location)
    }
  ]
}

locals {
  data_disks = [
    for disk_key, disk in var.instance.disks : {
      vm_name              = var.instance.name
      disk_key             = disk_key
      name                 = try(disk.name, join("-", [var.naming.managed_disk, disk_key]))
      resourcegroup        = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
      location             = coalesce(lookup(var.instance, "location", null), var.location)
      create_option        = try(disk.create_option, "Empty")
      disk_size_gb         = try(disk.disk_size_gb, 10)
      storage_account_type = try(disk.storage_account_type, "Standard_LRS")
      caching              = try(disk.caching, "ReadWrite")
      tags                 = try(disk.tags, null)
      lun                  = disk.lun
    }
  ]
}

locals {
  ext_keys = flatten([
    for ext_key, ext in try(var.instance.extensions, {}) : {
      vm_name              = var.instance.name
      ext_key              = ext_key
      name                 = ext_key
      publisher            = ext.publisher
      type                 = ext.type
      type_handler_version = ext.type_handler_version
      protected_settings   = try(ext.protected_settings, null)
      settings             = try(ext.settings, null)
    }
  ])
}
