To authenticate to the Virtual machine it is possible to use either SSH-keys or password for Linux VM's and password for Windows VM's.
This module allows flexibility in configuring virtual machines by either generating passwords and SSH keys internally or allowing users to bring their own.

## Using Internally Generated Password or SSH Key
When using the internally generated password (default for Windows) or SSH keys (default for Linux), you can simply provide the Key Vault ID where the secrets will be stored in your configuration. For example:

```hcl
module "vm-linux-ssh" {
  source = "cloudnationhq/vm/azure"
  version = "~> 1.3.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int = { subnet = module.network.subnets.int.id }
    }

    keyvault_id = module.kv.vault.id
  }
}
```
## Bringing Your Own Password or SSH Key
If you want to bring your own password or SSH key, you can set these as a property instead. For example:

```hcl
module "vm-linux-ssh" {
  source = "cloudnationhq/vm/azure"
  version = "~> 1.3.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int = { subnet = module.network.subnets.int.id }
    }

    username   = "linux-admin" ## default is "adminuser" if not set
    public_key = module.kv.tls_public_keys.vm-linux-demo-dev-key.value
  }
}
```

```hcl
module "vm-linux-password" {
  source = "cloudnationhq/vm/azure"
  version = "~> 1.3.1"

  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int = { subnet = module.network.subnets.int.id }
    }

    username = "linux-admin" ## default is "adminuser" if not set
    password = module.kv.secrets.vm-linux-demo-dev-password.value
  }
}
```