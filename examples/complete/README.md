This example highlights the complete usage.

## Usage

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 1.12"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  instance = local.instance
}
```

The module uses the below locals for configuration:

```hcl
locals {
  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    extensions    = local.extensions
    type          = "linux"

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
      mgt = {
        subnet = module.network.subnets.mgt.id
      }
    }
    disks = {
      db = {
        size_gb = 10
        lun     = 0
      }
      logs = {
        size_gb = 12
        lun     = 1
      }
    }
  }
}
```

```hcl
locals {
  extensions = {
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
