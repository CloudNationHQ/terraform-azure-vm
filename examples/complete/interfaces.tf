locals {
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
}
