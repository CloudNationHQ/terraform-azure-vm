This example illustrates the default virtual machine setup, in its simplest form.

## Usage: default

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 1.7"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    type          = "linux"
    name          = module.naming.linux_virtual_machine.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}
```

Additionally, for certain scenarios, the example below highlights the ability to use multiple virtual machines, enabling a broader setup.

## Usage: multiple

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 0.1"

  naming        = local.naming
  keyvault      = module.kv.vault.id
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
  depends_on    = [module.kv]

  for_each = local.vms

  instance = each.value
}
```

The module uses a local to iterate, generating a virtual machine for each key.

```hcl
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
