This deploys virtual machine extensions.

## Notes

To use settings or protected settings the jsonencode function needs to be used:

```hcl
settings = jsonencode({
  EncryptionOperation    = "EnableEncryption"
  KeyVaultURL            = module.kv.vault.vault_uri
  KeyVaultResourceId     = module.kv.vault.id
  KeyEncryptionAlgorithm = "RSA-OAEP"
  VolumeType             = "all"
})
```
```hcl
settings = jsonencode({
  workspaceId = data.azurerm_log_analytics_workspace.analytics.workspace_id
})
protected_settings = jsonencode({
  workspaceKey = data.azurerm_log_analytics_workspace.analytics.primary_shared_key
})
```
