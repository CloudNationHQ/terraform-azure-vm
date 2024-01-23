This example illustrates the implementation of extensions.

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 0.9"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    type          = "linux"
    name          = module.naming.linux_virtual_machine.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location
    extensions    = local.exts

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}
```

```hcl
locals {
  exts = {
    custom = {
      publisher            = "Microsoft.Azure.Extensions"
      type                 = "CustomScript"
      type_handler_version = "2.0"
      settings = {
        "commandToExecute" = "echo 'Hello World' > /tmp/helloworld.txt"
      }
    }
  }
}
```
