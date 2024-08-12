# Windows

This deploys a windows virtual machine.

## Types

```hcl
instance = object({
  type           = string
  name           = string
  resource_group = string
  location       = string
  interfaces     = map(object({
    subnet = string
    ip_configurations = map(object({
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
      public_ip_address_id          = optional(string)
      primary                       = optional(bool)
    }))
  }))
})
```
