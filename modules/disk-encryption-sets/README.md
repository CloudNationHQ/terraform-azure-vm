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

- [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) (resource)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_encryption_sets"></a> [encryption\_sets](#input\_encryption\_sets)

Description: Contains all disk encryption sets configuration

Type:

```hcl
map(object({
    name                      = optional(string)
    location                  = optional(string)
    resource_group_name       = optional(string)
    key_vault_key_id          = optional(string)
    managed_hsm_key_id        = optional(string)
    encryption_type           = optional(string)
    auto_key_rotation_enabled = optional(bool, false)
    federated_client_id       = optional(string)
    identity = optional(object({
      type         = optional(string, "SystemAssigned")
      identity_ids = optional(list(string))
    }), { type = "SystemAssigned" })
    tags = optional(map(string))
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

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

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

Description: Contains all disk encryption sets configuration
<!-- END_TF_DOCS -->