locals {
  extensions = {
    GuestConfigurationExtension = {
      publisher               = "Microsoft.GuestConfiguration"
      type                    = "ConfigurationforWindows"
      type_handler_version    = "1.1"
      autoUpgradeMinorVersion = true
    }
    encryption = {
      name                       = "AzureDiskEncryption"
      publisher                  = "Microsoft.Azure.Security"
      type                       = "AzureDiskEncryption"
      type_handler_version       = "2.2"
      auto_upgrade_minor_version = true
      settings = {
        "EncryptionOperation" : "EnableEncryption"
        "KeyVaultURL" : module.kv.vault.vault_uri
        "KeyVaultResourceId" : module.kv.vault.id
        "KeyEncryptionAlgorithm" : "RSA-OAEP"
        "VolumeType" : "all"
      }
    }
  }
}
