output "sets" {
  description = "Contains all availability sets configuration"
  value = {
    for k, v in azurerm_availability_set.avail : k => {
      id = v.id
    }
  }
}
