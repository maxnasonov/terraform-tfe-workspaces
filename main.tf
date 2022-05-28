# Individual workspace
resource "tfe_workspace" "workspace" {
  for_each = local.workspaces

  name                          = each.key
  description                   = "Workspace: ${each.key} | Triggered from path: ${each.value.vcs_identifier}${each.value.vcs_branch != null ? "@${each.value.vcs_branch}" : ""}:${each.value.working_directory != null ? each.value.working_directory : "/"}"
  allow_destroy_plan            = true
  organization                  = local.tfc_organization_name
  terraform_version             = each.value.terraform_version
  working_directory             = each.value.working_directory
  file_triggers_enabled         = true
  auto_apply                    = each.value.auto_apply
  execution_mode                = var.execution_mode
  structured_run_output_enabled = false
  tag_names                     = each.value.tag_names != null ? each.value.tag_names : [each.value.configuration_name]

  vcs_repo {
    branch         = each.value.vcs_branch
    identifier     = each.value.vcs_identifier
    oauth_token_id = var.oauth_token_id
  }
}

# Slack notification
resource "tfe_notification_configuration" "slack" {
  for_each = var.slacks

  name             = each.value.name
  enabled          = each.value.enabled
  destination_type = "slack"
  triggers         = ["run:created", "run:planning", "run:needs_attention", "run:applying", "run:completed", "run:errored"]
  url              = each.value.url
  workspace_id     = tfe_workspace.workspace[each.key].id
}

# Triggers
resource "tfe_run_trigger" "trigger" {
  for_each = var.triggers

  workspace_id  = tfe_workspace.workspace[each.value].id
  sourceable_id = tfe_workspace.workspace[each.key].id
}
