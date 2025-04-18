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

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

- <a name="requirement_tls"></a> [tls](#requirement\_tls) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.6)

- <a name="provider_tls"></a> [tls](#provider\_tls) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_key_vault_secret.secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.tls_private_key_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.tls_public_key_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) (resource)
- [azurerm_managed_disk.disks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) (resource)
- [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) (resource)
- [azurerm_virtual_machine_data_disk_attachment.at](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) (resource)
- [azurerm_virtual_machine_extension.ext](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) (resource)
- [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) (resource)
- [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [tls_private_key.tls_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_instance"></a> [instance](#input\_instance)

Description: Contains all virtual machine configuration

Type:

```hcl
object({
    name                                                   = string
    type                                                   = string
    resource_group                                         = optional(string, null)
    location                                               = optional(string, null)
    size                                                   = optional(string, "Standard_D2s_v3")
    computer_name                                          = optional(string, null)
    username                                               = optional(string, "adminuser")
    admin_username                                         = optional(string, "adminuser")
    password                                               = optional(string, null)
    public_key                                             = optional(string, null)
    license_type                                           = optional(string, null)
    allow_extension_operations                             = optional(bool, true)
    availability_set_id                                    = optional(string, null)
    custom_data                                            = optional(string, null)
    user_data                                              = optional(string, null)
    capacity_reservation_group_id                          = optional(string, null)
    virtual_machine_scale_set_id                           = optional(string, null)
    proximity_placement_group_id                           = optional(string, null)
    dedicated_host_group_id                                = optional(string, null)
    platform_fault_domain                                  = optional(number, null)
    source_image_id                                        = optional(string, null)
    dedicated_host_id                                      = optional(string, null)
    max_bid_price                                          = optional(number, null)
    edge_zone                                              = optional(string, null)
    disable_password_authentication                        = optional(bool, true)
    encryption_at_host_enabled                             = optional(bool, false)
    extensions_time_budget                                 = optional(string, null)
    patch_assessment_mode                                  = optional(string, "ImageDefault")
    patch_mode                                             = optional(string, null)
    priority                                               = optional(string, "Regular")
    provision_vm_agent                                     = optional(bool, true)
    reboot_setting                                         = optional(string, null)
    secure_boot_enabled                                    = optional(bool, false)
    vtpm_enabled                                           = optional(bool, false)
    zone                                                   = optional(string, null)
    bypass_platform_safety_checks_on_user_schedule_enabled = optional(bool, false)
    provisioning_vm_agent                                  = optional(bool, true)
    disk_controller_type                                   = optional(string, null)
    eviction_policy                                        = optional(string, null)
    tags                                                   = optional(map(string))
    additional_capabilities = optional(object({
      ultra_ssd_enabled   = optional(bool, false)
      hibernation_enabled = optional(bool, false)
    }), null)
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string, null)
    }), null)
    interfaces = map(object({
      name                           = optional(string)
      dns_servers                    = optional(list(string), [])
      accelerated_networking_enabled = optional(bool, false)
      ip_forwarding_enabled          = optional(bool, false)
      ip_config_name                 = optional(string, "ipconfig")
      private_ip_address_allocation  = optional(string, "Dynamic")
      private_ip_address             = optional(string, null)
      private_ip_address_version     = optional(string, "IPv4")
      public_ip_address_id           = optional(string, null)
      auxiliary_sku                  = optional(string, null)
      auxiliary_mode                 = optional(string, null)
      internal_dns_name_label        = optional(string, null)
      edge_zone                      = optional(string, null)
      tags                           = optional(map(string), null)
      ip_configurations = map(object({
        name                                               = optional(string)
        private_ip_address                                 = optional(string, null)
        public_ip_address_id                               = optional(string, null)
        private_ip_address_version                         = optional(string, "IPv4")
        subnet_id                                          = optional(string, null)
        primary                                            = optional(bool, false)
        gateway_load_balancer_frontend_ip_configuration_id = optional(string, null)
      }))
    }))
    generate_ssh_key = optional(object({
      enable           = optional(bool, false)
      algorithm        = optional(string, "RSA")
      rsa_bits         = optional(number, 4096)
      ecdsa_curve      = optional(string, null)
      expiration_date  = optional(string, null)
      not_before_date  = optional(string, null)
      value_wo_version = optional(number, null)
      value_wo         = optional(string, null)
      content_type     = optional(string, null)
    }), { enable = false })
    generate_password = optional(object({
      enable           = optional(bool, false)
      length           = optional(number, 24)
      special          = optional(bool, true)
      min_lower        = optional(number, 5)
      min_upper        = optional(number, 7)
      min_special      = optional(number, 4)
      min_numeric      = optional(number, 5)
      numeric          = optional(bool, null)
      upper            = optional(bool, null)
      lower            = optional(bool, null)
      override_special = optional(string, null)
      expiration_date  = optional(string, null)
      not_before_date  = optional(string, null)
      value_wo_version = optional(number, null)
      value_wo         = optional(string, null)
      content_type     = optional(string, null)
      keepers          = optional(map(string), null)
    }), { enable = false })
    os_disk = optional(object({
      name                             = optional(string, null)
      storage_account_type             = optional(string, "Standard_LRS")
      caching                          = optional(string, "ReadWrite")
      disk_size_gb                     = optional(number, null)
      security_encryption_type         = optional(string, null)
      write_accelerator_enabled        = optional(bool, false)
      disk_encryption_set_id           = optional(string, null)
      secure_vm_disk_encryption_set_id = optional(string, null)
      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string, null)
      }), null)
    }), {})
    source_image_reference = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string)
      # publisher = optional(string, null)
      # offer     = optional(string, null)
      # sku       = optional(string, null)
      # version   = optional(string, null)
    }), null)
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }), null)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }), null)
    disks = optional(map(object({
      name                              = optional(string, null)
      create_option_disk_attachment     = optional(string, "Attach")
      create_option                     = optional(string, "Empty")
      disk_size_gb                      = optional(number, 10)
      storage_account_type              = optional(string, "Standard_LRS")
      caching                           = optional(string, "ReadWrite")
      tags                              = optional(map(string), null)
      lun                               = number
      tier                              = optional(string, null)
      zone                              = optional(string, null)
      os_type                           = optional(string, null)
      edge_zone                         = optional(string, null)
      max_shares                        = optional(number, null)
      source_uri                        = optional(string, null)
      optimized_frequent_attach_enabled = optional(bool, null)
      public_network_access_enabled     = optional(bool, null)
      on_demand_bursting_enabled        = optional(bool, false)
      gallery_image_reference_id        = optional(string, null)
      performance_plus_enabled          = optional(bool, null)
      trusted_launch_enabled            = optional(bool, false)
      network_access_policy             = optional(string, null)
      logical_sector_size               = optional(number, null)
      source_resource_id                = optional(string, null)
      image_reference_id                = optional(string, null)
      secure_vm_disk_encryption_set_id  = optional(string, null)
      disk_encryption_set_id            = optional(string, null)
      security_type                     = optional(string, null)
      disk_access_id                    = optional(string, null)
      hyper_v_generation                = optional(string, null)
      disk_iops_read_write              = optional(number, null)
      disk_mbps_read_write              = optional(number, null)
      storage_account_id                = optional(string, null)
      write_accelerator_enabled         = optional(bool, false)
      disk_iops_read_only               = optional(number, null)
      disk_mbps_read_only               = optional(number, null)
      upload_size_bytes                 = optional(number, null)
    })), {})
    extensions = optional(map(object({
      name                        = optional(string, null)
      publisher                   = string
      type                        = string
      type_handler_version        = string
      settings                    = optional(any, null)
      protected_settings          = optional(any, null)
      auto_upgrade_minor_version  = optional(bool, true)
      automatic_upgrade_enabled   = optional(bool, false)
      failure_suppression_enabled = optional(bool, false)
      provision_after_extensions  = optional(list(string), [])
      tags                        = optional(map(string), null)
    })), {})
    enable_automatic_updates = optional(bool, true)
    hotpatching_enabled      = optional(bool, false)
    timezone                 = optional(string, null)
    winrm_listeners = optional(map(object({
      protocol        = string
      certificate_url = optional(string, null)
    })), {})
    secrets = optional(map(object({
      key_vault_id = string
      certificate = object({
        url   = string
        store = string
      })
    })), {})
    os_image_notification = optional(object({
      timeout = string
    }), null)
    gallery_applications = optional(map(object({
      tag                                         = optional(string, null)
      order                                       = optional(number, null)
      version_id                                  = string
      configuration_blob_uri                      = optional(string, null)
      automatic_upgrade_enabled                   = optional(bool, false)
      treat_failure_as_deployment_failure_enabled = optional(bool, false)
    })), {})
    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string, null)
    }), null)
    addtional_unattend_contents = optional(map(object({
      content = string
      setting = string
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_keyvault"></a> [keyvault](#input\_keyvault)

Description: keyvault id to store secrets

Type: `string`

Default: `null`

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region and can be used if location is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: used for naming purposes

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

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
