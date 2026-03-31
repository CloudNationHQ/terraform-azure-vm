resource "azurerm_disk_encryption_set" "this" {
  for_each = var.encryption_sets != null ? var.encryption_sets : {}

  name = coalesce(
    each.value.name,
    try(join("-", [var.naming.disk_encryption_set, each.key]), null)
  )

  resource_group_name = coalesce(
    each.value.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    each.value.location, var.location
  )

  key_vault_key_id          = each.value.key_vault_key_id
  managed_hsm_key_id        = each.value.managed_hsm_key_id
  encryption_type           = each.value.encryption_type
  auto_key_rotation_enabled = each.value.auto_key_rotation_enabled
  federated_client_id       = each.value.federated_client_id

  identity {
    type         = each.value.identity.type
    identity_ids = each.value.identity.identity_ids
  }

  tags = coalesce(
    each.value.tags, var.tags
  )
}
