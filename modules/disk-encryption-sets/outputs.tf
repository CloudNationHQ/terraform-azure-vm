output "sets" {
  description = "contains all disk encryption sets"
  value = {
    for k, v in azurerm_disk_encryption_set.sets : k => {
      id = v.id
    }
  }
}

#output "managed_identities" {
  #value = {
    #for k, v in azurerm_disk_encryption_set.sets : k => v.identity[0].principal_id
  #}
#}
