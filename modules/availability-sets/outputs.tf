output "sets" {
  description = "contains all availability sets"
  value = {
    for k, v in azurerm_availability_set.avail : k => {
      id = v.id
    }
  }
}
