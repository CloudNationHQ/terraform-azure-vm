output "instance" {
  description = "contains all virtual machine config"
  value       = var.instance.type == "linux" ? try(azurerm_linux_virtual_machine.this["vm"], null) : try(azurerm_windows_virtual_machine.this["vm"], null)
}

output "network_interfaces" {
  description = "contains all network interfaces config"
  value       = azurerm_network_interface.this
}
