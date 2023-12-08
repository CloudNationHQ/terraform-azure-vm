This section details the support for windows virtual machines.

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 0.4"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    type          = "windows"
    name          = module.naming.windows_virtual_machine.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    interfaces = {
      int = {
        subnet = module.network.subnets.internal.id
      }
    }
  }
}
```
