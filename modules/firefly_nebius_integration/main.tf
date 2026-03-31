terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }
}

data "http" "firefly_nebius_integration_request" {
  count  = var.skip_integration_request ? 0 : 1
  url    = "${var.firefly_endpoint}/integrations/nebius?onConflictUpdate=true"
  method = "POST"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${var.firefly_token}"
  }
  retry {
    attempts     = 3
    max_delay_ms = 5000
    min_delay_ms = 5000
  }
  request_body = jsonencode({
    "name"             = var.integration_name,
    "tenantId"         = var.tenant_id,
    "serviceAccountId" = var.service_account_id,
    "publicKeyId"      = var.public_key_id,
    "privateKey"       = var.private_key_pem,
    "isProd"           = var.is_prod,
    "policyVersion"    = var.policy_version
  })
}

locals {
  response_obj   = try(jsondecode(data.http.firefly_nebius_integration_request[0].response_body), {})
  integration_id = try(local.response_obj.integration.id, try(local.response_obj.integration._id, ""))
}
