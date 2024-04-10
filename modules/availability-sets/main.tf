# availability sets
resource "azurerm_availability_set" "avail" {
  for_each = try(var.availability_sets, {})

  name                         = try(each.value.name, join("-", [var.naming.availability_set, each.key]))
  location                     = try(each.value.location, var.location)
  resource_group_name          = try(each.value.resourcegroup, var.resourcegroup)
  managed                      = try(each.value.managed, true)
  platform_fault_domain_count  = try(each.value.platform_fault_domain_count, 3)
  platform_update_domain_count = try(each.value.platform_update_domain_count, 5)
  proximity_placement_group_id = try(each.value.proximity_placement_group_id, null)

  tags = try(each.value.tags, var.tags, {})
}
