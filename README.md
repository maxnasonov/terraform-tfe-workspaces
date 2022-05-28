# TFE/C workspaces Terraform module

[![Terraform](https://github.com/scalefactory/terraform-tfe-workspaces/actions/workflows/terraform.yml/badge.svg)](https://github.com/scalefactory/terraform-tfe-workspaces/actions/workflows/terraform.yml)

Terraform workspaces module which manages configuration and life-cycle of all
your Terraform Cloud workspaces. It is designed to be used from a dedicated
Terraform Cloud workspace that would provision and manage rest of your
workspaces using Terraform code (IaC).

## Project status

`terraform-tfe-workspaces` is an open source project published by [The Scale Factory](https://www.scalefactory.com).

We currently consider this project to be actively maintained and we will add new
features, keep it security patched and ready for use in production environments.

We’ll take a look at any issues or PRs you open and get back to you as soon as
we can. We don’t offer any formal SLA, but we’ll be checking on this project
periodically.

## Features

- Create a Terraform Cloud/Enterprise workspace
- Set configuration settings:
  - VCS
  - Variables
  - Alerts
  - Triggers
- Remove workspaces

## Usage example

Workspaces configured by this module will likely require credentials for
authenticating to the various services you wish to use.

For example, if we're configuring a workspace that requires AWS credentials, you
will configure using the following code:

_main.tf_:
```hcl
terraform {
  required_version = ">= 0.13.6, < 2.0"

  backend "remote" {
    organization = "scalefactory"

    workspaces {
      name = "terraform-cloud"
    }
  }
}

module "workspaces" {
  source = "../modules/terraform-tfe-workspaces"

  organization   = "scalefactory"
  oauth_token_id = var.oauth_token_id
  vcs_org        = "scalefactory"
  vcs_repo       = "terraform-infra"
  #tf_version     = "1.x.y"
  workspaces         = var.workspaces
  slacks             = var.slacks
  triggers           = var.triggers
  TFC_WORKSPACE_NAME = var.TFC_WORKSPACE_NAME

  vars = {
    AWS_ACCESS_KEY_ID = var.aws_access_key_id
  }

  sec_vars = {
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  }
}
```

_terraform.auto.tfvars_:
```terraform
workspaces = {
  shared       = "terraform/shared"
}
```

<!-- TODO
There is also a more complete [example](example/) which shows more features available.
-->
## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/scalefactory/terraform-tfe-workspaces/issues/new) section.

Full contributing [guidelines are covered here](CONTRIBUTING.md).

## Authors

* [Marko Bevc](https://github.com/mbevc1)
* [David O'Rourke](https://github.com/phyber)
* Full [contributors list](https://github.com/scalefactory/terraform-tfe-workspaces/graphs/contributors)

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.6, < 2.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.31.0 |

## Resources

| Name | Type |
|------|------|
| [tfe_notification_configuration.slack](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/notification_configuration) | resource |
| [tfe_run_trigger.trigger](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/run_trigger) | resource |
| [tfe_variable.vars](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.workspace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [tfe_workspace.current](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_vcs_repository_prefix"></a> [configuration\_vcs\_repository\_prefix](#input\_configuration\_vcs\_repository\_prefix) | Prefix for Terraform configuraiton repositories. It is used for default workspace tags.<br>For example, for prefix "tfconf-" and "tfconf-great-code" the Terraform configuration name would be "great-code" and<br>will be used to tag corresponding workspaces with "great-code" tag. | `string` | `"tfconf-"` | no |
| <a name="input_default_vcs_identifier"></a> [default\_vcs\_identifier](#input\_default\_vcs\_identifier) | GitHub organization name and GitHub repository name separated by slash, e.g. `mygithuborg/tfp-super-thing` | `string` | n/a | yes |
| <a name="input_execution_mode"></a> [execution\_mode](#input\_execution\_mode) | Terraform worskapce execution more: remote, local or agent | `string` | `"remote"` | no |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | ID of the oAuth token for the VCS connection | `string` | n/a | yes |
| <a name="input_slacks"></a> [slacks](#input\_slacks) | Map definning Slack notification options | `map(any)` | `{}` | no |
| <a name="input_tf_version"></a> [tf\_version](#input\_tf\_version) | Version of Terraform to use in workspace | `string` | `null` | no |
| <a name="input_tfc_workspace_slug"></a> [tfc\_workspace\_slug](#input\_tfc\_workspace\_slug) | TFC workspace slug | `string` | n/a | yes |
| <a name="input_triggers"></a> [triggers](#input\_triggers) | Map for TFE trigger relations workspace->workspace2 | `map(any)` | `{}` | no |
| <a name="input_vars"></a> [vars](#input\_vars) | Map defining default workspace variables | `map(any)` | `{}` | no |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | Workspaces map where we define workspace and its path | `map` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
