This example outlines the configuration and deployment of availability sets to ensure high availability and fault tolerance.

## Usage

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 2.4"

  naming        = local.naming
  keyvault      = module.kv.vault.id
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
  depends_on    = [module.kv]

  instance = {
    name = module.naming.virtual_machine.name
    type = "linux"
    interfaces = {
      dcroot001 = {
        subnet = module.network.subnets.int.id
        ip_configurations = {
          config1 = {
            private_ip_address_allocation = "Dynamic"
          }
        }
      }
    }
    disks = {
      dcroot001 = {
        disk_size_gb = 128
        lun          = 0
      }
    }
    availability_set_id = module.availability.sets.demo.id
  }
}

module "availability" {
  source  = "cloudnationhq/vm/azure//modules/availability-sets"
  version = "~> 0.1"

  availability_sets = {
    demo = {
      name          = module.naming.availability_set.name
      resourcegroup = module.rg.groups.demo.name
      location      = module.rg.groups.demo.location
    }
  }
}
```
