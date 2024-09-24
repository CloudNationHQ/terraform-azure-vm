module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 4.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    cidr           = ["10.18.0.0/16"]

    subnets = {
      int = {
        cidr = ["10.18.1.0/24"]
        nsg  = {}
      }
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 2.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    secrets = {
      tls_keys = {
        vm-linux-key = {
          algorithm = "RSA"
          key_size  = 2048
        }
      }
      random_string = {
        vm-linux-password = {
          length  = 24
          special = false
        }
        vm-windows-password = {
          length  = 24
          special = false
        }
      }
    }
  }
}

module "vm-linux-ssh" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 4.0"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name           = "${module.naming.linux_virtual_machine.name}-01"
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    public_key     = module.kv.tls_public_keys.vm-linux-key.value
    type           = "linux"

    interfaces = {
      int1 = {
        subnet = module.network.subnets.int.id
        ip_configurations = {
          config1 = {
            private_ip_address_allocation = "Dynamic"
          }
        }
      }
    }
  }
}

module "vm-linux-password" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 4.0"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name           = "${module.naming.linux_virtual_machine.name}-02"
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    password       = module.kv.secrets.vm-linux-password.value
    type           = "linux"

    interfaces = {
      int1 = {
        subnet = module.network.subnets.int.id
        ip_configurations = {
          config1 = {
            private_ip_address_allocation = "Dynamic"
          }
        }
      }
    }
  }
}

module "vm-windows-password" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 4.0"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name           = "${module.naming.windows_virtual_machine.name}-03"
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    password       = module.kv.secrets.vm-windows-password.value
    type           = "windows"

    interfaces = {
      int1 = {
        subnet = module.network.subnets.int.id
        ip_configurations = {
          config1 = {
            primary = true
          }
        }
      }
    }
  }
}
