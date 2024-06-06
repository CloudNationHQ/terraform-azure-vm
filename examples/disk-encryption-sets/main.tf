module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 2.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]

    subnets = {
      sn1 = {
        cidr = ["10.18.1.0/24"]
        nsg  = {}
      }
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.1"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    keys = {
      disk = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey",
        ]
      }
    }
  }
}

module "vm" {
  source = "../../"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv, module.encryption]

  instance = {
    name          = module.naming.linux_virtual_machine.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    type          = "linux"

    interfaces = {
      int = {
        subnet = module.network.subnets.sn1.id
      }
    }
    disks = {
      db = {
        size_gb                = 10
        lun                    = 0
        disk_encryption_set_id = module.encryption.sets.set1.id
      }
    }
  }
}

module "encryption" {
  source = "../../modules/disk-encryption-sets"

  naming = local.naming

  disk_encryption_sets = {
    set1 = {
      location         = module.rg.groups.demo.location
      resourcegroup    = module.rg.groups.demo.name
      key_vault_key_id = module.kv.keys.disk.id
      key_vault_id     = module.kv.vault.id
      #auto_key_rotation_enabled = true
      #key_vault_key_id          = module.kv.keys.disk.versionless_id # needed for auto key rotation
      identity = {
        type = "SystemAssigned, UserAssigned"
      }
    }
  }
}
