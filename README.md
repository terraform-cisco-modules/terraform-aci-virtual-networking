<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - Virtual Networking Module

A Terraform module to configure ACI Virtual Networking.

This module is part of the Cisco [*Intersight as Code*](https://cisco.com/go/intersightascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level Intersight object model.

A comprehensive example using this module is available here: https://github.com/terraform-cisco-modules/easy-aci-complete

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.1.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.1.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | Model data. | `any` | n/a | yes |
| <a name="input_vmm_password_1"></a> [vmm\_password\_1](#input\_vmm\_password\_1) | Password for VMM Credentials Policy. | `string` | `""` | no |
| <a name="input_vmm_password_2"></a> [vmm\_password\_2](#input\_vmm\_password\_2) | Password for VMM Credentials Policy. | `string` | `""` | no |
| <a name="input_vmm_password_3"></a> [vmm\_password\_3](#input\_vmm\_password\_3) | Password for VMM Credentials Policy. | `string` | `""` | no |
| <a name="input_vmm_password_4"></a> [vmm\_password\_4](#input\_vmm\_password\_4) | Password for VMM Credentials Policy. | `string` | `""` | no |
| <a name="input_vmm_password_5"></a> [vmm\_password\_5](#input\_vmm\_password\_5) | Password for VMM Credentials Policy. | `string` | `""` | no |
## Outputs

No outputs.
## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.vmm_domain_uplinks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmm_uplinks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_vmm_controller.controllers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_controller) | resource |
| [aci_vmm_credential.credentials](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_credential) | resource |
| [aci_vmm_domain.vmm_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_domain) | resource |
| [aci_vswitch_policy.vswitch_policies](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vswitch_policy) | resource |
<!-- END_TF_DOCS -->