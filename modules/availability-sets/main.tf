# availability sets
resource "azurerm_availability_set" "avail" {
  for_each = var.availability_sets != null ? var.availability_sets : {}

  location = try(
    each.value.location, var.location
  )

  resource_group_name = try(
    each.value.resource_group_name, var.resource_group_name
  )

  name = try(
    each.value.name, join("-", [var.naming.availability_set, each.key])
  )

  managed                      = each.value.managed
  platform_fault_domain_count  = each.value.platform_fault_domain_count
  platform_update_domain_count = each.value.platform_update_domain_count
  proximity_placement_group_id = each.value.proximity_placement_group_id

  tags = coalesce(
    each.value.tags, var.tags
  )
}
