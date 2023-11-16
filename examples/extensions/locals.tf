locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret", "network_interface"]
}

locals {
  exts = {
    custom = {
      publisher            = "Microsoft.Azure.Extensions"
      type                 = "CustomScript"
      type_handler_version = "2.0"
      settings = {
        "commandToExecute" = "echo 'Hello World' > /tmp/helloworld.txt"
      }
    }
    defender = {
      publisher            = "Microsoft.Azure.AzureDefenderForServers"
      type                 = "MDE.Linux"
      type_handler_version = "1.0"
    }
  }
}
