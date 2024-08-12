# Authentication

This displays authentication settings available for deployment.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string
  public_key     = optional(string)
  type           = string
  interfaces     = map(object({
    subnet = string
    ip_configurations = map(object({
      private_ip_address_allocation = string
    }))
  }))
})
```

## Notes

public_key is used for linux machines, while password is used for windows machines in a BYO (Bring Your Own) configuration.

Both are optional; if omitted, secrets will be automatically generated.
