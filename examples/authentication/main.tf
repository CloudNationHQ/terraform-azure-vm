module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 2.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]

    subnets = {
      int = {
        cidr = ["10.18.1.0/24"]
        nsg  = {}
      }
      mgt = {
        cidr = ["10.18.2.0/24"]
        nsg  = {}
      }
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.1"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

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
  version = "~> 1.3.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = "${module.naming.linux_virtual_machine.name}-01"
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int1 = { subnet = module.network.subnets.int.id }
    }

    username   = "linux-admin" ## default is "adminuser" if not set
    public_key = module.kv.tls_public_keys.vm-linux-key.value
  }
}

module "vm-linux-password" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 1.3.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = "${module.naming.linux_virtual_machine.name}-02"
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int2 = { subnet = module.network.subnets.int.id }
    }

    username = "linux-admin" ## default is "adminuser" if not set
    password = module.kv.secrets.vm-linux-password.value
  }
}

module "vm-windows-password" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 1.3.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = "${module.naming.windows_virtual_machine.name}-03"
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "windows"

    interfaces = {
      int3 = { subnet = module.network.subnets.int.id }
    }

    username = "windows-admin" ## default is "adminuser" if not set
    password = module.kv.secrets.vm-windows-password.value
  }
}
