# Complete

This example highlights the complete usage.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string
  type           = string
  additional_capabilities = optional(object({
    ultra_ssd_enabled = bool
  }))
  source_image_reference = optional(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))
  interfaces = map(object({
    subnet = string
    ip_configurations = map(object({
      primary                       = optional(bool)
      private_ip_address_allocation = optional(string)
      private_ip_address            = optional(string)
    }))
  }))
  disks = optional(map(object({
    size_gb = number
    lun     = number
  })))
  extensions = optional(map(object({
    publisher            = string
    type                 = string
    type_handler_version = string
    settings = object({
      commandToExecute = string
    })
  })))
})
```

## Notes

source_image_reference has default values but can be overridden if needed.
