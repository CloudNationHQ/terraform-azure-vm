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
  version = "~> 3.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 5.0"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]
  instance = {
    type           = "linux"
    name           = module.naming.linux_virtual_machine.name
    resource_group = module.rg.groups.demo.name
    location       = module.rg.groups.demo.location
    generate_ssh_key = {
      enable = true
    }
    source_image_reference = {
      offer     = "UbuntuServer"
      publisher = "Canonical"
      sku       = "18.04-LTS"
    }

    custom_data = <<EOF
I2Nsb3VkLWNvbmZpZwpwYWNrYWdlX3VwZ3JhZGU6IHRydWUKcGFja2FnZXM6CiAg
LSBhcGFjaGUyCnJ1bmNtZDoKICAtIGVjaG8gIjxodG1sPjxib2R5PjxoMT5XZWxj
b21lIHRvIE15IFdlYiBQYWdlPC9oMT48L2JvZHk+PC9odG1sPiIgPiAvdmFyL3d3
dy9odG1sL2luZGV4Lmh0bWwK
EOF

    interfaces = {
      int = {
        ip_configurations = {
          config1 = {
            subnet_id                     = module.network.subnets.int.id
            private_ip_address_allocation = "Dynamic"
            primary                       = true
          }
        }
      }
    }
  }
}
