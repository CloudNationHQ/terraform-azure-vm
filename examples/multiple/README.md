The following example can be used for referencing specific subnets in configurations with multiple virtual machines.

## Usage

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 1.6"

  naming        = local.naming
  keyvault      = module.kv.vault.id
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location
  depends_on    = [module.kv]

  for_each = local.vms

  instance = each.value
}
```

The below local holds all our virtual machine config.

```hcl
locals {
  vms = {
    dcroot001 = {
      name = "vmdcroot001"
      type = "windows"
      size = "Standard_D2s_v5"
      interfaces = {
        int1 = {
          name   = "vmdcroot-int1"
          subnet = module.network.subnets.int.id
        }
      }
      disks = {
        dsk1 = {
          name         = "vmdcroot001-dsk1"
          disk_size_gb = 128
        }
      }
    }
    dcroot002 = {
      name = "vmdcroot002"
      type = "windows"
      size = "Standard_D4ds_v5"
      interfaces = {
        int1 = {
          name   = "vmdcroot002-int1"
          subnet = module.network.subnets.mgt.id
        }
      }
      disks = {
        dsk1 = {
          name         = "vmdcroot002-dsk1"
          disk_size_gb = 128
        }
      }
    }
  }
}
```

If we need specific information regarding the interfaces on each vm from another module, the below output can be used.

```hcl
output "interfaces" {
  value = {
    for vm_name, vm_config in local.vms : vm_name => {
      for interface_name, interface_config in vm_config.interfaces : interface_name => {
        subnet_id = interface_config.subnet
      }
    }
  }
}
```

We can do more or less the same with for example disks.

```hcl
output "disks" {
  value = {
    for vm_name, vm_config in local.vms : vm_name => {
      for disk_name, disk_config in vm_config.disks : disk_name => {
        name    = disk_config.name
        size_gb = disk_config.disk_size_gb
      }
    }
  }
}
```

In another module, reference it as `module.vm.interfaces.dcroot002.int1.subnet` or `module.vm.disks.dcroot001.dsk1.name`.
