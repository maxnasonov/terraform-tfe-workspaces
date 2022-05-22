data "tfe_workspace" "current" {
  organization = local.tfc_organization_name
  name         = local.tfc_workspace_name
}

