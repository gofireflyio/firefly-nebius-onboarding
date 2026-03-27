resource "nebius_iam_v1_service_account" "firefly_service_account" {
  count       = var.existing_service_account_id == null ? 1 : 0
  parent_id   = var.project_id
  name        = local.service_account_name
  description = "[DO NOT REMOVE] Firefly service account"
}

resource "nebius_iam_v1_group" "firefly_group" {
  count     = var.existing_group_id == null ? 1 : 0
  parent_id = var.tenant_id
  name      = local.group_name
}

resource "nebius_iam_v1_group_membership" "firefly_membership" {
  depends_on = [
    nebius_iam_v1_service_account.firefly_service_account,
    nebius_iam_v1_group.firefly_group
  ]
  parent_id = local.group_id
  member_id = local.service_account_id
}

resource "nebius_iam_v1_access_permit" "firefly_viewer_access" {
  depends_on  = [nebius_iam_v1_group_membership.firefly_membership]
  parent_id   = local.group_id
  resource_id = var.tenant_id
  role        = "viewer"
}

# Audit log permissions for event-driven integration
resource "nebius_iam_v1_access_permit" "firefly_audit_viewer" {
  count       = var.enable_audit_logs ? 1 : 0
  depends_on  = [nebius_iam_v1_group_membership.firefly_membership]
  parent_id   = local.group_id
  resource_id = var.tenant_id
  role        = "auditlogs.audit-event-viewer"
}

resource "nebius_iam_v1_access_permit" "firefly_audit_exporter" {
  count       = var.enable_audit_logs ? 1 : 0
  depends_on  = [nebius_iam_v1_group_membership.firefly_membership]
  parent_id   = local.group_id
  resource_id = var.tenant_id
  role        = "auditlogs.audit-event-exporter"
}
