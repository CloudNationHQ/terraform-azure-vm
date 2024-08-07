output "vm" {
  value     = module.vm.instance
  sensitive = true
}

output "subscription_id" {
  value = module.vm.subscription_id
}
