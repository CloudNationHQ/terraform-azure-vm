output "interfaces" {
  value = {
    for vm_name, vm_config in local.vms : vm_name => {
      for interface_name, interface_config in vm_config.interfaces : interface_name => {
        subnet_id = interface_config.subnet
      }
    }
  }
}
