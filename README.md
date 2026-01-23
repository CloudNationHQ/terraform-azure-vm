# Virtual Machine

This Terraform module simplifies the configuration and management of virtual machines. It offers extensive customization options to match your specific deployment needs, streamlining the provisioning and maintenance process.

## Features

Flexibility to incorporate multiple extensions

Utilization of Terratest for robust validation

Ability to use multiple interfaces and disks

Supports both system and multiple user assigned identities

Supports custom data integration

Compatible with both Linux and Windows environments

Supports availability sets to enhance fault tolerance and availability

Offers optional multiple ip configurations per interface

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

- [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) (resource)
- [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) (resource)
- [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) (resource)
- [azurerm_virtual_machine_data_disk_attachment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) (resource)
- [azurerm_virtual_machine_extension.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) (resource)
- [azurerm_windows_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_instance"></a> [instance](#input\_instance)

Description: Contains all virtual machine configuration

Type:

```hcl
object({
    name                                                   = string
    type                                                   = string
    resource_group_name                                    = optional(string)
    location                                               = optional(string)
    size                                                   = optional(string, "Standard_D2s_v3")
    computer_name                                          = optional(string)
    username                                               = optional(string, "adminuser")
    password                                               = optional(string)
    public_key                                             = optional(string)
    license_type                                           = optional(string)
    allow_extension_operations                             = optional(bool, true)
    availability_set_id                                    = optional(string)
    custom_data                                            = optional(string)
    user_data                                              = optional(string)
    capacity_reservation_group_id                          = optional(string)
    virtual_machine_scale_set_id                           = optional(string)
    proximity_placement_group_id                           = optional(string)
    dedicated_host_group_id                                = optional(string)
    platform_fault_domain                                  = optional(number)
    source_image_id                                        = optional(string)
    dedicated_host_id                                      = optional(string)
    max_bid_price                                          = optional(number)
    edge_zone                                              = optional(string)
    disable_password_authentication                        = optional(bool, true)
    encryption_at_host_enabled                             = optional(bool, false)
    extensions_time_budget                                 = optional(string)
    patch_assessment_mode                                  = optional(string, "ImageDefault")
    patch_mode                                             = optional(string)
    priority                                               = optional(string, "Regular")
    provision_vm_agent                                     = optional(bool, true)
    reboot_setting                                         = optional(string)
    secure_boot_enabled                                    = optional(bool, false)
    vtpm_enabled                                           = optional(bool, false)
    zone                                                   = optional(string)
    bypass_platform_safety_checks_on_user_schedule_enabled = optional(bool, false)
    disk_controller_type                                   = optional(string)
    eviction_policy                                        = optional(string)
    os_managed_disk_id                                     = optional(string)
    tags                                                   = optional(map(string))
    additional_capabilities = optional(object({
      ultra_ssd_enabled   = optional(bool, false)
      hibernation_enabled = optional(bool, false)
    }), null)
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
    interfaces = map(object({
      name                           = optional(string)
      dns_servers                    = optional(list(string), [])
      accelerated_networking_enabled = optional(bool, false)
      ip_forwarding_enabled          = optional(bool, false)
      ip_config_name                 = optional(string, "ipconfig")
      private_ip_address_allocation  = optional(string, "Dynamic")
      private_ip_address             = optional(string)
      private_ip_address_version     = optional(string, "IPv4")
      public_ip_address_id           = optional(string)
      auxiliary_sku                  = optional(string)
      auxiliary_mode                 = optional(string)
      internal_dns_name_label        = optional(string)
      edge_zone                      = optional(string)
      tags                           = optional(map(string))
      ip_configurations = map(object({
        name                                               = optional(string)
        private_ip_address                                 = optional(string)
        public_ip_address_id                               = optional(string)
        private_ip_address_version                         = optional(string, "IPv4")
        subnet_id                                          = optional(string)
        primary                                            = optional(bool, false)
        gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      }))
    }))
    generate_ssh_key = optional(object({
      enable           = optional(bool, false)
      algorithm        = optional(string, "RSA")
      rsa_bits         = optional(number, 4096)
      ecdsa_curve      = optional(string)
      expiration_date  = optional(string)
      not_before_date  = optional(string)
      value_wo_version = optional(number)
      value_wo         = optional(string)
      content_type     = optional(string)
    }), { enable = false })
    generate_password = optional(object({
      enable           = optional(bool, false)
      length           = optional(number, 24)
      special          = optional(bool, true)
      min_lower        = optional(number, 5)
      min_upper        = optional(number, 7)
      min_special      = optional(number, 4)
      min_numeric      = optional(number, 5)
      numeric          = optional(bool)
      upper            = optional(bool)
      lower            = optional(bool)
      override_special = optional(string)
      expiration_date  = optional(string)
      not_before_date  = optional(string)
      value_wo_version = optional(number)
      value_wo         = optional(string)
      content_type     = optional(string)
      keepers          = optional(map(string))
    }), { enable = false })
    os_disk = optional(object({
      name                             = optional(string)
      storage_account_type             = optional(string, "StandardSSD_LRS")
      caching                          = optional(string, "ReadWrite")
      disk_size_gb                     = optional(number)
      security_encryption_type         = optional(string)
      write_accelerator_enabled        = optional(bool, false)
      disk_encryption_set_id           = optional(string)
      secure_vm_disk_encryption_set_id = optional(string)
      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string)
      }), null)
    }), {})
    source_image_reference = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string, "latest")
    }), null)
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }), null)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }), null)
    disks = optional(map(object({
      name                              = optional(string)
      create_option_disk_attachment     = optional(string, "Attach")
      create_option                     = optional(string, "Empty")
      disk_size_gb                      = optional(number, 10)
      storage_account_type              = optional(string, "Standard_LRS")
      caching                           = optional(string, "ReadWrite")
      tags                              = optional(map(string))
      lun                               = number
      tier                              = optional(string)
      zone                              = optional(string)
      os_type                           = optional(string)
      edge_zone                         = optional(string)
      max_shares                        = optional(number)
      source_uri                        = optional(string)
      optimized_frequent_attach_enabled = optional(bool)
      public_network_access_enabled     = optional(bool)
      on_demand_bursting_enabled        = optional(bool, false)
      gallery_image_reference_id        = optional(string)
      performance_plus_enabled          = optional(bool)
      trusted_launch_enabled            = optional(bool, false)
      network_access_policy             = optional(string)
      logical_sector_size               = optional(number)
      source_resource_id                = optional(string)
      image_reference_id                = optional(string)
      secure_vm_disk_encryption_set_id  = optional(string)
      disk_encryption_set_id            = optional(string)
      security_type                     = optional(string)
      disk_access_id                    = optional(string)
      hyper_v_generation                = optional(string)
      disk_iops_read_write              = optional(number)
      disk_mbps_read_write              = optional(number)
      storage_account_id                = optional(string)
      write_accelerator_enabled         = optional(bool, false)
      disk_iops_read_only               = optional(number)
      disk_mbps_read_only               = optional(number)
      upload_size_bytes                 = optional(number)
    })), {})
    extensions = optional(map(object({
      name                        = optional(string)
      publisher                   = string
      type                        = string
      type_handler_version        = string
      settings                    = optional(map(any), {})
      protected_settings          = optional(map(string), {})
      auto_upgrade_minor_version  = optional(bool, true)
      automatic_upgrade_enabled   = optional(bool, false)
      failure_suppression_enabled = optional(bool, false)
      provision_after_extensions  = optional(list(string), [])
      protected_settings_from_key_vault = optional(object({
        secret_url      = string
        source_vault_id = string
      }))
      tags = optional(map(string))
    })), {})
    automatic_updates_enabled = optional(bool, true)
    hotpatching_enabled       = optional(bool, false)
    timezone                  = optional(string)
    winrm_listeners = optional(map(object({
      protocol        = string
      certificate_url = optional(string)
    })), {})
    secrets = optional(map(object({
      key_vault_id = string
      certificate = object({
        url   = string
        store = optional(string)
      })
    })), {})
    os_image_notification = optional(object({
      timeout = string
    }), null)
    gallery_applications = optional(map(object({
      tag                                         = optional(string)
      order                                       = optional(number)
      version_id                                  = string
      configuration_blob_uri                      = optional(string)
      automatic_upgrade_enabled                   = optional(bool, false)
      treat_failure_as_deployment_failure_enabled = optional(bool, false)
    })), {})
    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string)
    }), null)
    additional_unattend_content = optional(map(object({
      content = string
      setting = string
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region and can be used if location is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: used for naming purposes

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group and can be used if resourcegroup is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference)

Description: Default source image reference configuration to use when not specified at the instance level

Type:

```hcl
object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
```

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_instance"></a> [instance](#output\_instance)

Description: contains all virtual machine config

### <a name="output_network_interfaces"></a> [network\_interfaces](#output\_network\_interfaces)

Description: contains all network interfaces config
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-vm/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-vm" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/compute/virtual-machines)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/compute/resource-manager/Microsoft.Compute/ComputeRP/stable/2023-07-01/virtualMachine.json)
