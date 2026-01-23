locals {
  extensions = {
    GuestConfigurationExtension = {
      publisher               = "Microsoft.GuestConfiguration"
      type                    = "ConfigurationforWindows"
      type_handler_version    = "1.1"
      autoUpgradeMinorVersion = true
    }
  }
}
