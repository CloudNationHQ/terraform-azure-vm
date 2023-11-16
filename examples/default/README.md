


```hcl
module "vm" {
  source  = "cloudnationhq/vmss/azure"
  version = "~> 0.1"

  naming = local.naming

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
      name          = "vmdemodev1"
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      keyvault      = module.kv.vault.id
      public_key    = module.kv.tls_public_keys.vm.value
      type          = "linux"
      interfaces = {
        vm1 = {
          subnet = module.network.subnets.int.id
        }
      }
    }
    vm2 = {
      name          = "vmdemodev2"
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      keyvault      = module.kv.vault.id
      password      = module.kv.secrets.vm.value
      type          = "windows"
      interfaces = {
        vm2 = {
          subnet = module.network.subnets.int.id
        }
      }
    }
    vm3 = {
      name          = "vmdemodev3"
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      keyvault      = module.kv.vault.id
      public_key    = module.kv.tls_public_keys.vm.value
      type          = "linux"
      interfaces = {
        vm3 = {
          subnet = module.network.subnets.int.id
        }
      }
    }
  }
}
```
