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
      private_ip_address_version    = try(nic.private_ip_address_version, "IPv4")
      public_ip_address_id          = try(nic.public_ip_address_id, null)
      auxiliary_sku                 = try(nic.auxiliary_sku, null)
      auxiliary_mode                = try(nic.auxiliary_mode, null)
      internal_dns_name_label       = try(nic.internal_dns_name_label, null)
      edge_zone                     = try(nic.edge_zone, null)
      tags                          = try(nic.tags, null)
      resourcegroup                 = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
      location                      = coalesce(lookup(var.instance, "location", null), var.location)
    }
  ]
}

locals {
  data_disks = [
    for disk_key, disk in try(var.instance.disks, {}) : {

      vm_name                           = var.instance.name
      disk_key                          = disk_key
      name                              = try(disk.name, join("-", [var.naming.managed_disk, disk_key]))
      resourcegroup                     = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
      location                          = coalesce(lookup(var.instance, "location", null), var.location)
      create_option                     = try(disk.create_option, "Empty")
      disk_size_gb                      = try(disk.disk_size_gb, 10)
      storage_account_type              = try(disk.storage_account_type, "Standard_LRS")
      caching                           = try(disk.caching, "ReadWrite")
      tags                              = try(disk.tags, null)
      lun                               = disk.lun
      tier                              = try(disk.tier, null)
      zone                              = try(disk.zone, var.instance.zone, null)
      os_type                           = try(disk.os_type, null)
      edge_zone                         = try(disk.edge_zone, null)
      max_shares                        = try(disk.max_shares, 10)
      source_uri                        = try(disk.source_uri, null)
      optimized_frequent_attach_enabled = try(disk.optimized_frequent_attach_enabled, null)
      public_network_access_enabled     = try(disk.public_network_access_enabled, null)
      on_demand_bursting_enabled        = try(disk.on_demand_bursting_enabled, false)
      gallery_image_reference_id        = try(disk.gallery_image_reference_id, null)
      performance_plus_enabled          = try(disk.performance_plus_enabled, null)
      trusted_launch_enabled            = try(disk.trusted_launch_enabled, false)
      network_access_policy             = try(disk.network_access_policy, null)
      logical_sector_size               = try(disk.logical_sector_size, null)
      source_resource_id                = try(disk.source_resource_id, null)
      image_reference_id                = try(disk.image_reference_id, null)
      secure_vm_disk_encryption_set_id  = try(disk.secure_vm_disk_encryption_set_id, null)
      disk_encryption_set_id            = try(disk.disk_encryption_set_id, null)
      security_type                     = try(disk.security_type, null)
      disk_access_id                    = try(disk.disk_access_id, null)
      hyper_v_generation                = try(disk.hyper_v_generation, null)
      storage_account_id                = try(disk.storage_account_id, null)
    }
  ]
}

locals {
  ext_keys = length(lookup(var.instance, "extensions", {})) > 0 ? {
    for ext_name, ext in lookup(var.instance, "extensions", {}) :
    "${var.instance.name}-${ext_name}" => {

      name                 = try(ext.name, ext_name)
      vm_name              = var.instance.name,
      publisher            = ext.publisher,
      type                 = ext.type,
      type_handler_version = ext.type_handler_version,
      settings             = lookup(ext, "settings", {}),
      protected_settings   = lookup(ext, "protected_settings", {}),
    }
  } : {}
}
