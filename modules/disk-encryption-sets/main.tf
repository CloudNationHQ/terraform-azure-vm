#works
resource "azurerm_user_assigned_identity" "identity" {
  for_each = {
    for k, v in var.disk_encryption_sets : k => v
    if contains(["UserAssigned", "SystemAssigned, UserAssigned"], v.identity.type)
  }

  name                = try(each.value.identity.name, "uai-${each.key}")
  location            = try(each.value.location, var.location)
  resource_group_name = try(each.value.resourcegroup, var.resourcegroup)
  tags                = try(each.value.identity.tags, var.tags, {})


}

resource "azurerm_role_assignment" "des_crypto_officer_user_assigned" {
  for_each = {
    for k, v in var.disk_encryption_sets : k => v
    if contains(["UserAssigned", "SystemAssigned, UserAssigned"], v.identity.type)
  }

  scope                = each.value.key_vault_id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.identity[each.key].principal_id
}

resource "azurerm_role_assignment" "des_crypto_service_encryption_user_user_assigned" {
  for_each = {
    for k, v in var.disk_encryption_sets : k => v
    if contains(["UserAssigned", "SystemAssigned, UserAssigned"], v.identity.type)
  }

  scope                = each.value.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.identity[each.key].principal_id
}


resource "azurerm_role_assignment" "des_crypto_officer_system_assigned" {
  for_each = { for k, v in var.disk_encryption_sets : k => v if v.identity.type == "SystemAssigned" }

  scope                = each.value.key_vault_id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_disk_encryption_set.sets[each.key].identity[0].principal_id

  depends_on = [
    azurerm_disk_encryption_set.sets
  ]
}

resource "azurerm_role_assignment" "des_crypto_service_encryption_user_system_assigned" {
  for_each = { for k, v in var.disk_encryption_sets : k => v if v.identity.type == "SystemAssigned" }

  scope                = each.value.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.sets[each.key].identity[0].principal_id

  depends_on = [
    azurerm_disk_encryption_set.sets
  ]
}

resource "azurerm_disk_encryption_set" "sets" {
  for_each = var.disk_encryption_sets

  name                      = try(each.value.name, join("-", [var.naming.disk_encryption_set, each.key]))
  location                  = try(each.value.location, var.location)
  resource_group_name       = try(each.value.resourcegroup, var.resourcegroup)
  key_vault_key_id          = each.value.key_vault_key_id
  auto_key_rotation_enabled = try(each.value.auto_key_rotation_enabled, false)
  encryption_type           = try(each.value.encryption_type, "EncryptionAtRestWithCustomerKey")
  federated_client_id       = try(each.value.federated_client_id, null)
  tags                      = try(each.value.tags, var.tags, {})

  identity {
    type         = each.value.identity.type
    identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], each.value.identity.type) ? [azurerm_user_assigned_identity.identity[each.key].id] : []
  }

  depends_on = [
    azurerm_role_assignment.des_crypto_officer_user_assigned,
    azurerm_role_assignment.des_crypto_service_encryption_user_user_assigned,
  ]
}
