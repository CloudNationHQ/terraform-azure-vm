module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.26"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 10.0"


  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.18.0.0/16"]
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
  version = "~> 6.0"


  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    secrets = {
      tls_keys = {
        vm1 = {
          algorithm = "RSA"
          rsa_bits  = 2048
        }
      }
    }
  }
}

module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 8.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  virtual_machine = {
    name     = module.naming.virtual_machine.name_unique
    type     = "linux"
    size     = "Standard_D2s_v3"
    username = "adminuser"
    os_disk = {
      storage_account_type = "Standard_LRS"
    }
    public_key = module.kv.tls_public_keys.vm1.value

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
  version = "~> 8.0"

  availability_sets = {
    demo = {
      name                = module.naming.availability_set.name
      resource_group_name = module.rg.groups.demo.name
      location            = module.rg.groups.demo.location
    }
  }
}
