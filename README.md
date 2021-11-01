# kong-multispace-route-example

This module deploys apps in different spaces while making them
available from a single host through a path prefix. It demonstrates
how network policies can be used to accomodate traffic across 
spaces and potentially even across org boundaries

## how it works

Based on the teams count (`var.teams`) the module does the following:

- Creates `n` spaces
- Deploys a test app in each space
- Deploys a Kong API gateway
- Configures the API gateway to forward `/teamN` path to space `N` hosted test app
- Sets up network policies for cross space container-to-container traffic 

## usage

Provide the required variables and then run:

```shell
terraform init
terraform apply
```

## License

License is MIT

<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudfoundry"></a> [cloudfoundry](#provider\_cloudfoundry) | 0.14.2 |
| <a name="provider_hsdp"></a> [hsdp](#provider\_hsdp) | 0.26.3 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kong"></a> [kong](#module\_kong) | philips-labs/kong/cloudfoundry | 2.3.3 |

## Resources

| Name | Type |
|------|------|
| [cloudfoundry_app.teams](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_network_policy.policies](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_route.internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_space.spaces](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/space) | resource |
| [cloudfoundry_space_users.users](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/space_users) | resource |
| [random_pet.deploy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [cloudfoundry_domain.internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_org.org](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/org) | data source |
| [hsdp_config.cf](https://registry.terraform.io/providers/philips-software/hsdp/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cf_org_name"></a> [cf\_org\_name](#input\_cf\_org\_name) | n/a | `string` | n/a | yes |
| <a name="input_cf_password"></a> [cf\_password](#input\_cf\_password) | n/a | `string` | n/a | yes |
| <a name="input_cf_space_name"></a> [cf\_space\_name](#input\_cf\_space\_name) | n/a | `string` | n/a | yes |
| <a name="input_cf_user"></a> [cf\_user](#input\_cf\_user) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | `number` | `4` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway"></a> [api\_gateway](#output\_api\_gateway) | n/a |

<!--- END_TF_DOCS --->
