locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret", "network_interface", "managed_disk", "user_assigned_identity"]
}

locals {
  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    extensions    = local.extensions
    type          = "linux"

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
        ip_configurations = {
          config1 = {
            primary                       = true
            private_ip_address_allocation = "Dynamic"
          }
          config2 = {
            private_ip_address = "10.18.1.25"
          }
        }
      }
      mgt = {
        subnet = module.network.subnets.mgt.id
        ip_configurations = {
          config1 = {
            private_ip_address = "10.18.2.25"
          }
        }
      }
    }
    disks = {
      db = {
        size_gb = 10
        lun     = 0
      }
      logs = {
        size_gb = 12
        lun     = 1
      }
    }
  }
}

locals {
  extensions = {
    custom = {
      publisher            = "Microsoft.Azure.Extensions"
      type                 = "CustomScript"
      type_handler_version = "2.0"
      settings = {
        "commandToExecute" = "echo 'Hello World' > /tmp/helloworld.txt"
      }
    }
  }
}
