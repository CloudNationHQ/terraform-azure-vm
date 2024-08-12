# Extensions

This deploys virtual machine extensions.

## Types

```hcl
instance = object({
  type           = string
  name           = string
  resource_group = string
  location       = string
  extensions     = optional(map(object({
    publisher            = string
    type                 = string
    type_handler_version = string
    settings             = map(string)
  })))
  interfaces     = map(object({
    subnet            = string
    ip_configurations = map(object({
      private_ip_address_allocation = optional(string)
      private_ip_address            = optional(string)
      primary                       = optional(bool)
    }))
  }))
})
```
