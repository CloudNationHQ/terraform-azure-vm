This section outlines the configuration of multiple network interfaces, enabling advanced networking capabilities and increased connectivity options.

## Usage

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 1.3.1"

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
        subnet = module.network.subnets.int.id
        ip_configurations = {
          config1 = {
            private_ip_address_allocation = "Dynamic"
          }
          config2 = {
            private_ip_address = "10.18.1.25"
          }
        }
      }
      mgt = {
        subnet = module.network.subnets.mgt.id
        ip_configurations = {
          config1 = {
            private_ip_address = "10.18.2.25"
          }
        }
      }
    }
  }
}
```
