module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

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
  version = "~> 8.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    address_space  = ["10.18.0.0/16"]
    subnets = {
      int = {
        address_prefixes       = ["10.18.1.0/24"]
        network_security_group = {}
      }
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 4.0"

  naming = local.naming

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 6.0"

  naming              = local.naming
  keyvault            = module.kv.vault.id
  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location
  depends_on          = [module.kv]

  instance = {
    name = module.naming.virtual_machine.name
    type = "linux"
    generate_ssh_key = {
      enable = true
    }
    source_image_reference = {
      offer     = "UbuntuServer"
      publisher = "Canonical"
      sku       = "18.04-LTS"
    }

    interfaces = {
      dcroot001 = {
        ip_configurations = {
          config1 = {
            subnet_id = module.network.subnets.int.id
            primary   = true
          }
        }
      }
    }
    availability_set_id = module.availability.sets.demo.id
  }
}

module "availability" {
  source  = "cloudnationhq/vm/azure//modules/availability-sets"
  version = "~> 6.0"

  availability_sets = {
    demo = {
      name                = module.naming.availability_set.name
      resource_group_name = module.rg.groups.demo.name
      location            = module.rg.groups.demo.location
    }
  }
}
