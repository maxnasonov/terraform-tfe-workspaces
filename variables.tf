#// Should be provided from the Terraform Cloud environment
#variable aws_access_key_id {
#  description = "The AWS_ACCESS_KEY_ID for TerraformCloud runs"
#  type        = string
#}
#
#// Should be provided from the Terraform Cloud environment
#variable aws_secret_access_key {
#  description = "The AWS_SECRET_ACCESS_KEY for TerraformCloud runs"
#  type        = string
#}

variable "oauth_token_id" {
  description = "ID of the oAuth token for the VCS connection"
  type        = string
}

variable "tf_version" {
  description = "Version of Terraform to use in workspace"
  type        = string
  default     = null
}

variable "workspaces" {
  description = "Workspaces map where we define workspace and its path"
  #type        = map(any)
  default = {}
}

variable "slacks" {
  description = "Map definning Slack notification options"
  type        = map(any)
  default     = {}
}

variable "triggers" {
  description = "Map for TFE trigger relations workspace->workspace2"
  type        = map(any)
  default     = {}
}

variable "execution_mode" {
  description = "Terraform worskapce execution more: remote, local or agent"
  type        = string
  default     = "remote"
}

variable "default_vcs_identifier" {
  type        = string
  description = "GitHub organization name and GitHub repository name separated by slash, e.g. `mygithuborg/tfp-super-thing`"
}

variable "vars" {
  description = "Map defining default workspace variables"
  type        = map(any)
  default     = {}
}

variable "secret_resolutions" {
  description = "Map defining the actual values of the secrets"
  type        = map(any)
  default     = {}
}

variable "tfc_workspace_slug" {
  description = "TFC workspace slug"
  type        = string
}