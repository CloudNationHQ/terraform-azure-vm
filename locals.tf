locals {
  interfaces = flatten([
    for interface_key, nic in var.instance.interfaces : {

      interface_key                 = interface_key
      name                          = try(nic.name, join("-", [var.naming.network_interface, interface_key]))
      dns_servers                   = try(nic.dns_servers, [])
      enable_accelerated_networking = try(nic.enable_accelerated_networking, false)
      enable_ip_forwarding          = try(nic.enable_ip_forwarding, false)
      subnet_id                     = nic.subnet
      private_ip_address_allocation = try(nic.private_ip_address_allocation, "Dynamic")
      private_ip_address            = try(nic.private_ip_address, null)
      public_ip_address_id          = try(nic.public_ip_address_id, null)
      resourcegroup                 = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
      location                      = coalesce(lookup(var.instance, "location", null), var.location)
    }
  ])
}

locals {
  data_disks = flatten([
    for disk_key, disk in try(var.instance.disks, {}) : {

      disk_key             = disk_key
      name                 = try(disk.name, join("-", [var.naming.managed_disk, disk_key]))
      resourcegroup        = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
      location             = coalesce(lookup(var.instance, "location", null), var.location)
      create_option        = try(disk.create_option, "Empty")
      disk_size_gb         = try(disk.disk_size_gb, 10)
      storage_account_type = try(disk.storage_account_type, "Standard_LRS")
      caching              = try(disk.caching, "ReadWrite")
      lun = try(
        disk.lun,
        length(keys(var.instance.disks)) > 0 ? index(keys(var.instance.disks), disk_key) : 0
      )
    }
  ])
}

locals {
  ext_keys = flatten([
    for ext_key, ext in try(var.instance.extensions, {}) : {

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

