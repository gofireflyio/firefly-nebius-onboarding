resource "tls_private_key" "firefly_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "nebius_iam_v1_auth_public_key" "firefly_public_key" {
  depends_on = [nebius_iam_v1_service_account.firefly_service_account]
  parent_id  = var.tenant_id
  account = {
    service_account = {
      id = local.service_account_id
    }
  }
  data = tls_private_key.firefly_key.public_key_pem
}
