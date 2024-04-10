This module enables flexible virtual machine setup by supporting both auto generated and user supplied (bring your own) ssh keys and passwords for tailored access.

## Usage: generated password or ssh key

To utilize the generated password or ssh key, simply specify the key vault id in your configuration:

```hcl
module "vm" {
  source = "cloudnationhq/vm/azure"
  version = "~> 1.13"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int1 = {
        subnet = module.network.subnets.int.id
      }
    }

    keyvault_id = module.kv.vault.id
  }
}
```

## Usage: bringing your own password or ssh key

To use your own password or SSH key, use the below properties in your configuration:

```hcl
module "vm" {
  source = "cloudnationhq/vm/azure"
  version = "~> 1.3"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    public_key    = module.kv.tls_public_keys.vm-linux-demo-dev-key.value
    type          = "linux"

    interfaces = {
      int1 = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}
```

```hcl
module "vm" {
  source = "cloudnationhq/vm/azure"
  version = "~> 1.3"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    password      = module.kv.secrets.vm-linux-demo-dev-password.value
    type          = "linux"

    interfaces = {
      int1 = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}
```
