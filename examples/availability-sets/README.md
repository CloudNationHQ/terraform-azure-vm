# Availability Sets

This deploys availability sets on the virtual machine to be utilized.

## Types

```hcl
instance = object({
  type           = string
  name           = string
  resource_group = string
  location       = string
  custom_data    = optional(string)
  interfaces     = map(object({
    subnet            = string
    ip_configurations = map(object({
      private_ip_address_allocation = optional(string)
      private_ip_address            = optional(string)
      primary                       = optional(bool)
    }))
  }))
  availability_set_id = optional(string)
})
```

```hcl
availability_sets = map(object({
  name           = string
  resource_group = string
  location       = string
}))
```

## Notes

The submodule enables setting up multiple availability sets and assigning virtual machines to specific zones.
