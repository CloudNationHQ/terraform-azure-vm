output "vm" {
  description = "contains all virtual machine config"
  value       = var.vm.type == "linux" ? try(azurerm_linux_virtual_machine.vm["linux"], null) : try(azurerm_windows_virtual_machine.vm["windows"], null)
}

output "subscriptionId" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}
