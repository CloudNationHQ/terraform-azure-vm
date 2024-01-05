module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.2"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 1.1.1"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]

    subnets = {
      int = {
        cidr = ["10.18.1.0/24"]
      }
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.4"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 0.8"

  keyvault = module.kv.vault.id
  naming   = local.naming

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
  depends_on = [module.kv]
}

resource "azurerm_user_assigned_identity" "identity_1" {
  location            = module.rg.groups.demo.location
  name                = "${local.naming.user_assigned_identity}-id1"
  resource_group_name = module.rg.groups.demo.name
}

resource "azurerm_user_assigned_identity" "identity_2" {
  location            = module.rg.groups.demo.location
  name                = "${local.naming.user_assigned_identity}-id2"
  resource_group_name = module.rg.groups.demo.name
}
