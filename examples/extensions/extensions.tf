locals {
  extensions = {
    GuestConfigurationExtension = {
      publisher               = "Microsoft.GuestConfiguration"
      type                    = "ConfigurationforWindows"
      type_handler_version    = "1.1"
      autoUpgradeMinorVersion = true
    }
    AADLoginForWindows = {
      name                       = "AADLogin"
      publisher                  = "Microsoft.Azure.ActiveDirectory"
      type                       = "AADLoginForWindows"
      type_handler_version       = "2.2"
      auto_upgrade_minor_version = false
    }
  }
}
