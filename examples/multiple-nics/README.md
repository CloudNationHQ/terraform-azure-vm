# Multiple Network Interfaces

This deploys multiple network interfaces.

## Types

```hcl
instance = object({
  type           = string
  name           = string
  resource_group = string
  location       = string
  interfaces     = map(object({
    subnet            = string
    ip_configurations = map(object({
      primary                       = optional(bool)
      private_ip_address_allocation = optional(string)
      private_ip_address            = optional(string)
    }))
  }))
})
```
