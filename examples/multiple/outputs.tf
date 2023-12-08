output "interfaces" {
  value = {
    for vm_name, vm_config in local.vms : vm_name => {
      for interface_name, interface_config in vm_config.interfaces : interface_name => {
        subnet_id = interface_config.subnet
      }
    }
  }
}

output "disks" {
  value = {
    for vm_name, vm_config in local.vms : vm_name => {
      for disk_name, disk_config in vm_config.disks : disk_name => {
        name    = disk_config.name
        size_gb = disk_config.disk_size_gb
      }
    }
  }
}
