data "http" "firefly_login" {
  count  = var.firefly_secret_key != "" ? 1 : 0
  url    = "${var.firefly_endpoint}/account/access_keys/login"
  method = "POST"
  request_headers = {
    Content-Type = "application/json"
  }
  request_body = jsonencode({
    "accessKey" = var.firefly_access_key,
    "secretKey" = var.firefly_secret_key
  })
}

locals {
  login_response = try(jsondecode(data.http.firefly_login[0].response_body), {})
  firefly_token  = lookup(local.login_response, "access_token", "error")
}

module "firefly_nebius_integration" {
  depends_on = [
    nebius_iam_v1_auth_public_key.firefly_public_key,
    data.http.firefly_login
  ]
  source = "./modules/firefly_nebius_integration"

  firefly_endpoint         = var.firefly_endpoint
  firefly_token            = local.firefly_token
  tenant_id                = var.tenant_id
  integration_name         = local.integration_name
  service_account_id       = local.service_account_id
  public_key_id            = nebius_iam_v1_auth_public_key.firefly_public_key.id
  private_key_pem          = tls_private_key.firefly_key.private_key_pem
  is_prod                  = var.is_prod
  skip_integration_request = var.skip_integration_request
  policy_version           = local.policy_version
}
