locals {
  # Policy version - increment when changing permissions
  # v1.0.0 - Initial
  policy_version = "1.0.0"

  name_prefix = var.prefix != "" ? "${var.prefix}-" : ""
  name_suffix = var.suffix != "" ? "-${var.suffix}" : ""

  service_account_name = "${local.name_prefix}firefly-svc${local.name_suffix}"
  group_name           = "${local.name_prefix}firefly-group${local.name_suffix}"
  tenant_name          = data.nebius_iam_v1_tenant.current.name
  integration_name     = var.integration_name != "" ? var.integration_name : local.tenant_name

  service_account_id = var.existing_service_account_id != null ? var.existing_service_account_id : (
    length(nebius_iam_v1_service_account.firefly_service_account) > 0 ?
    nebius_iam_v1_service_account.firefly_service_account[0].id : ""
  )

  group_id = var.existing_group_id != null ? var.existing_group_id : (
    length(nebius_iam_v1_group.firefly_group) > 0 ?
    nebius_iam_v1_group.firefly_group[0].id : ""
  )
}
