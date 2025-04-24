output "instance" {
  description = "contains all virtual machine config"
  value       = var.instance.type == "linux" ? try(azurerm_linux_virtual_machine.vm[var.instance.name], null) : try(azurerm_windows_virtual_machine.vm[var.instance.name], null)
}

output "network_interfaces" {
  description = "contains all network interfaces config"
  value       = azurerm_network_interface.nic
}
