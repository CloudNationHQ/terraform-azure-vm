## Usage: default

```hcl
module "vm" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 0.1"

  keyvault      = module.kv.vault.id
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
  naming        = local.naming
  depends_on    = [module.kv]

  vm = {
    type = "linux"
    name = module.naming.linux_virtual_machine.name

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}
```

## Usage: multiple

```hcl
module "vm" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 0.1"

  naming        = local.naming
  keyvault      = module.kv.vault.id
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
  depends_on    = [module.kv]

  for_each = local.vms

  vm = each.value
}
```

```hcl
locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret", "network_interface"]
}

locals {
  vms = {
    vm1 = {
      name = "vm-demo-dev1"
      type = "linux"
      interfaces = {
        vm1 = {
          subnet = module.network.subnets.int.id
        }
      }
    }
    vm2 = {
      name = "vm-demo-dev2"
      type = "linux"
      interfaces = {
        vm2 = {
          subnet = module.network.subnets.int.id
        }
      }
    }
    vm3 = {
      name = "vm-demo-dev3"
      type = "windows"
      interfaces = {
        vm3 = {
          subnet = module.network.subnets.int.id
        }
      }
    }
  }
}
```
