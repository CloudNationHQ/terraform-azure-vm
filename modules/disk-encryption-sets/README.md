# Disk Encryption Sets

This submodule focuses on the management of disk encryption sets

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.61 |

## Resources

| Name | Type |
|------|------|
| [azurerm_disk_encryption_set.sets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_role_assignment.des_crypto_officer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_disk_encryption_sets"></a> [disk\_encryption\_sets](#input\_disk\_encryption\_sets) | describes all disk encryption sets | `any` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | default azure region to be used. | `string` | `null` | no |
| <a name="input_naming"></a> [naming](#input\_naming) | used for naming purposes | `map(string)` | `null` | no |
| <a name="input_resourcegroup"></a> [resourcegroup](#input\_resourcegroup) | default resource group to be used. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be added to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sets"></a> [sets](#output\_sets) | contains all disk encryption sets |
