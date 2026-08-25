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
      mgt = {
        address_prefixes       = ["10.18.2.0/24"]
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
      random_string = {
        vm1 = {
          length  = 24
          special = false
        }
      }
    }
  }
}

module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 8.0"


  virtual_machine = {
    type     = "windows"
    size     = "Standard_D2s_v3"
    username = "adminuser"
    os_disk = {
      storage_account_type = "Standard_LRS"
    }
    name                = module.naming.windows_virtual_machine.name_unique
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
    password            = module.kv.secrets.vm1.value

    source_image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2022-Datacenter"
    }

    interfaces = {
      int = {
        ip_configurations = {
          config1 = {
            subnet_id = module.network.subnets.int.id
            primary   = true
          }
          config2 = {
            private_ip_address = "10.18.1.25"
            subnet_id          = module.network.subnets.int.id
          }
        }
      }
      mgt = {
        ip_configurations = {
          config1 = {
            subnet_id          = module.network.subnets.mgt.id
            private_ip_address = "10.18.2.25"
            primary            = true
          }
        }
      }
    }
  }
}
