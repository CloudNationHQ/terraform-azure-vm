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
      name     = module.naming.resource_group.name_unique
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
  }
}

module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 4.0"

  naming         = local.naming
  keyvault       = module.kv.vault.id
  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location
  depends_on     = [module.kv]

  instance = {
    name = module.naming.virtual_machine.name
    type = "linux"
    interfaces = {
      dcroot001 = {
        subnet = module.network.subnets.int.id
        ip_configurations = {
          config1 = {
            private_ip_address_allocation = "Dynamic"
          }
        }
      }
    }
    availability_set_id = module.availability.sets.demo.id
  }
}

module "availability" {
  source  = "cloudnationhq/vm/azure//modules/availability-sets"
  version = "~> 4.0"

  availability_sets = {
    demo = {
      name           = module.naming.availability_set.name
      resource_group = module.rg.groups.demo.name
      location       = module.rg.groups.demo.location
    }
  }
}
