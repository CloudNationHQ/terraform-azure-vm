module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "prd"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "northeurope"
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
      mgt = {
        cidr = ["10.18.2.0/24"]
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
  }
}

module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 4.0"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name           = module.naming.linux_virtual_machine.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    extensions     = local.extensions
    type           = "linux"
    interfaces     = local.interfaces
    extensions     = local.extensions

    source_image_reference = {
      publisher = "Debian"
      offer     = "debian-11"
      sku       = "11-backports-gen2"
      version   = "latest"
    }

    disks = {
      db = {
        size_gb = 10
        lun     = 0
      }
    }
  }
}
