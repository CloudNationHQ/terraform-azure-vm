locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "network_interface", "key_vault_secret"]
}

locals {
  vms = {
    vm1 = {
      name          = "vmdemodev1"
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      type          = "windows"
      interfaces = {
        vm1 = {
          subnet = module.network.subnets.int.id
        }
      }
    }
    vm2 = {
      name          = "vmdemodev2"
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      type          = "windows"
      interfaces = {
        vm2 = {
          subnet = module.network.subnets.int.id
        }
      }
    }
  }
}
