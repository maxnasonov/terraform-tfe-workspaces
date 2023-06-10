locals {
  tfc_organization_name = split("/", var.tfc_workspace_slug)[0]
  tfc_workspace_name    = split("/", var.tfc_workspace_slug)[1]
}

locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.

  # Default variables. Assignment decision is made based on tags.
  default_vars = flatten([
    for workspace_name, workspace_params in var.workspaces : [
      # At least one element of the workspace's `var_tag` should match to at least one variable tag.
      # If the variable does not have any defined tags, it value will be assigned to all workspaces.
      for var_key, var_params in var.vars : {
        workspace_name = workspace_name
        name           = var_key
        value          = var_params.value
        category       = lookup(var_params, "category", "terraform")
        sensitive      = lookup(var_params, "sensitive", false)
      } if length(setintersection(lookup(var_params, "tags", []), lookup(workspace_params, "var_tags", []))) > 0 || length(lookup(var_params, "tags", [])) == 0
    ]
  ])

  # Per-workspace variables
  workspace_vars = flatten([
    for workspace_name, workspace_params in var.workspaces : [
      for var_key, var_params in lookup(workspace_params, "vars", {}) : {
        workspace_name = workspace_name
        name           = var_key
        value          = var_params.value
        category       = lookup(var_params, "category", "terraform")
        hcl            = lookup(var_params, "hcl", false)
        sensitive      = lookup(var_params, "sensitive", false)
      }
    ]
  ])

  workspaces = { for workspace_name, workspace_params in var.workspaces : workspace_name => {
    name               = workspace_name
    terraform_version  = lookup(workspace_params, "terraform_version", local.tf_version)
    working_directory  = lookup(workspace_params, "path", null)
    auto_apply         = lookup(workspace_params, "auto_apply", false)
    tag_names          = lookup(workspace_params, "tag_names", null)
    vcs_branch         = lookup(workspace_params, "branch", null)
    vcs_identifier     = lookup(workspace_params, "vcs_identifier", var.default_vcs_identifier)
    configuration_name = lookup(workspace_params, "vcs_identifier", null) == null ? strrev(split("/", strrev(workspace_params.path))[0]) : replace(strrev(split("/", strrev(workspace_params.vcs_identifier))[0]), var.configuration_vcs_repository_prefix, "")
  } }
}

resource "tfe_variable" "vars" {
  # Project back into a map
  for_each = {
    for v in concat(local.default_vars, local.workspace_vars) : "${v.workspace_name}.${v.name}" => v
  }

  category     = lookup(each.value, "category", "terraform")
  key          = each.value.name
  value        = each.value.value
  hcl          = lookup(each.value, "hcl", false)
  workspace_id = tfe_workspace.workspace[each.value.workspace_name].id
  description  = "${each.value.name} for TerraformCloud"
  sensitive    = each.value.sensitive
}
