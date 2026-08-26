locals {
  extensions = {
    GuestConfigurationExtension = {
      publisher                  = "Microsoft.GuestConfiguration"
      type                       = "ConfigurationforWindows"
      type_handler_version       = "1.29"
      auto_upgrade_minor_version = true
    }

    AADLoginForWindows = {
      name                       = "AADLogin"
      publisher                  = "Microsoft.Azure.ActiveDirectory"
      type                       = "AADLoginForWindows"
      type_handler_version       = "2.2"
      auto_upgrade_minor_version = false
    }

    # KeyVaultForWindows v4.0 has heterogeneously-typed top-level settings keys
    # (secretsManagementSettings vs authenticationSettings), so it can only be passed
    # through the module now that extensions.settings takes a pre-serialized json string.
    KeyVaultForWindows = {
      name                       = "KVVMExtensionForWindows"
      publisher                  = "Microsoft.Azure.KeyVault"
      type                       = "KeyVaultForWindows"
      type_handler_version       = "4.0"
      auto_upgrade_minor_version = true

      settings = jsonencode({
        secretsManagementSettings = {
          observedCertificates = [
            {
              url                      = module.kv.certs.vmcert.versionless_secret_id
              certificateStoreName     = "MY"
              certificateStoreLocation = "LocalMachine"
            }
          ]
        }
        # required because the vm carries a user-assigned identity - without this the
        # extension can't tell which identity to authenticate as.
        authenticationSettings = {
          msiEndpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
          msiClientId = module.uai.identity.client_id
        }
      })
    }
  }
}
