# Custom Data

This deploys and applies custom data.

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
})
```

## Notes

You can encode the cloud-init.yaml file using base64 -i cloud-init.yaml. The resulting base64 string can then be used as input for the custom data property.
