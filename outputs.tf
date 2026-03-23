output "instance" {
  description = "contains all virtual machine config"
  value       = var.instance.type == "linux" ? try(azurerm_linux_virtual_machine.this["vm"], null) : try(azurerm_windows_virtual_machine.this["vm"], null)
}

output "network_interfaces" {
  description = "contains all network interfaces config"
  value       = azurerm_network_interface.this
}

output "disks" {
  description = "contains all managed disks config"
  value       = azurerm_managed_disk.this
}

output "disk_attachments" {
  description = "contains all data disk attachments config"
  value       = azurerm_virtual_machine_data_disk_attachment.this
}

output "extensions" {
  description = "contains all virtual machine extensions config"
  value       = azurerm_virtual_machine_extension.this
}
