This example illustrates a virtual machine setup with system-assigned identity

## Usage: system-assigned identity

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 0.7"

  keyvault   = module.kv.vault.id
  naming     = local.naming

  instance = {
    type          = "linux"
    name          = module.naming.linux_virtual_machine.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    identity = {
      type         = "SystemAssigned"
    }

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}
```

This example illustrates a virtual machine setup with user-assigned identity

## Usage: user-assigned identity

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 0.7"

  keyvault   = module.kv.vault.id
  naming     = local.naming

  instance = {
    type          = "linux"
    name          = module.naming.linux_virtual_machine.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    identity = {
      type         = "UserAssigned"
    }

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}
```

This example illustrates a virtual machine setup with both system-assigned and user-assigned identities

## Usage: both system-assigned and user-assigned identities

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 0.7"

  keyvault   = module.kv.vault.id
  naming     = local.naming

  instance = {
    type          = "linux"
    name          = module.naming.linux_virtual_machine.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    identity = {
      type         = "SystemAssigned, UserAssigned"
    }

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}
```

This example illustrates a virtual machine setup with both system-assigned and multiple user-assigned identities

## Usage: both system-assigned and multiple user-assigned identities

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 0.7"

  keyvault   = module.kv.vault.id
  naming     = local.naming

  instance = {
    type          = "linux"
    name          = module.naming.linux_virtual_machine.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location
    
    identity = {
      type         = "SystemAssigned, UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.identity_1.id, azurerm_user_assigned_identity.identity_2.id]
    }

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
    }
  }
}

resource "azurerm_user_assigned_identity" "identity1" {
  location            = var.location
  name                = "${local.naming.user_assigned_identity}-test1"
  resource_group_name = module.rg.groups.vm.name
}

resource "azurerm_user_assigned_identity" "identity2" {
  location            = var.location
  name                = "${local.naming.user_assigned_identity}-tes2"
  resource_group_name = module.rg.groups.vm.name
}
```