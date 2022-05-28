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

variable "configuration_vcs_repository_prefix" {
  type = "string"
  default = "tfconf-"
  description = <<-EOT
  Prefix for Terraform configuraiton repositories. It is used for default workspace tags.
  For example, for prefix "tfconf-" and "tfconf-great-code" the Terraform configuration name would be "great-code" and
  will be used to tag corresponding workspaces with "great-code" tag.
  EOT
}