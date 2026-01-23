module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.26"

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
  version = "~> 9.0"

  naming = local.naming

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
  version = "~> 4.0"

  naming = local.naming

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    secrets = {
      tls_keys = {
        vm1 = {
          algorithm = "RSA"
        }
      }
      random_string = {
        vm2 = {
          length  = 24
          special = false
        }
        vm3 = {
          length  = 24
          special = false
        }
        vm4 = {
          length  = 24
          special = false
        }
      }

      certs = {
        webcert = {
          subject            = "CN=vm-auth-demo"
          validity_in_months = 12
          key_usage          = ["digitalSignature", "keyEncipherment"]
        }
      }
    }
  }
}

module "vm-linux-ssh" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 7.0"

  naming = local.naming

  instance = {
    name                = "${module.naming.linux_virtual_machine.name}-01"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    public_key          = module.kv.tls_public_keys.vm1.value
    type                = "linux"

    source_image_reference = {
      offer     = "UbuntuServer"
      publisher = "Canonical"
      sku       = "18.04-LTS"
    }

    interfaces = {
      int1 = {
        ip_configurations = {
          config1 = {
            subnet_id = module.network.subnets.int.id
            primary   = true
          }
        }
      }
    }
  }
}

module "vm-linux-password" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 7.0"

  naming = local.naming

  instance = {
    name                = "${module.naming.linux_virtual_machine.name}-02"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    password            = module.kv.secrets.vm2.value
    type                = "linux"

    source_image_reference = {
      offer     = "UbuntuServer"
      publisher = "Canonical"
      sku       = "18.04-LTS"
    }

    interfaces = {
      int2 = {
        ip_configurations = {
          config1 = {
            subnet_id = module.network.subnets.int.id
            primary   = true
          }
        }
      }
    }
  }
}

module "vm-windows-password" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 7.0"

  naming = local.naming

  instance = {
    name                = "${module.naming.windows_virtual_machine.name}-03"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    password            = module.kv.secrets.vm3.value
    type                = "windows"

    source_image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2022-Datacenter"
    }

    interfaces = {
      int3 = {
        ip_configurations = {
          config1 = {
            subnet_id = module.network.subnets.int.id
            primary   = true
          }
        }
      }
    }
  }
}
