# Availability Sets

This submodule focuses on the management of availability sets

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_availability_set.avail](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) (resource)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_availability_sets"></a> [availability\_sets](#input\_availability\_sets)

Description: Contains all availabiliy sets configuration

Type:

```hcl
map(object({
    name                         = optional(string)
    location                     = optional(string)
    resource_group               = optional(string)
    managed                      = optional(bool, true)
    platform_fault_domain_count  = optional(number, 3)
    platform_update_domain_count = optional(number, 5)
    proximity_placement_group_id = optional(string, null)
    tags                         = optional(map(string))
  }))
```

Default: `null`

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: Used for naming purposes

Type: `map(string)`

Default: `null`

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_sets"></a> [sets](#output\_sets)

Description: Contains all availability sets configuration
<!-- END_TF_DOCS -->
