output "vm" {
  value     = module.vm.instance
  sensitive = true
}

output "subscriptionId" {
  value = module.vm.subscriptionId
}
