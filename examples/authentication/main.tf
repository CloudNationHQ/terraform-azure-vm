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
  version = "~> 1.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]

    subnets = {
      int = { cidr = ["10.18.1.0/24"] }
      mgt = { cidr = ["10.18.2.0/24"] }
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
        vm-linux-demo-dev-key = {
          algorithm = "RSA"
          key_size  = 2048
        }
      }
      random_string = {
        vm-linux-demo-dev-password = {
          length  = 24
          special = false
        }
        vm-windows-demo-dev-password = {
          length  = 24
          special = false
        }
      }
    }
  }
}

module "vm-linux-ssh" {
  source = "../.."
  # version = "~> 0.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int = { subnet = module.network.subnets.int.id }
    }

    username   = "linux-admin" ## default is "adminuser" if not set
    public_key = module.kv.tls_public_keys.vm-linux-demo-dev-key.value
  }
}

module "vm-linux-password" {
  source = "../.."
  # version = "~> 0.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int = { subnet = module.network.subnets.int.id }
    }

    username = "linux-admin" ## default is "adminuser" if not set
    password = module.kv.secrets.vm-linux-demo-dev-password.value
  }
}

module "vm-windows-password" {
  source = "../.."
  # version = "~> 0.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.windows_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "windows"

    interfaces = {
      int = { subnet = module.network.subnets.int.id }
    }

    username = "windows-admin" ## default is "adminuser" if not set
    password = module.kv.secrets.vm-windows-demo-dev-password.value
  }
}
