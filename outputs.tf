output "integration_name" {
  value = local.integration_name
}

output "policy_version" {
  value = local.policy_version
}

output "service_account_id" {
  value = local.service_account_id
}

output "public_key_id" {
  value = nebius_iam_v1_auth_public_key.firefly_public_key.id
}

output "fingerprint" {
  value = try(nebius_iam_v1_auth_public_key.firefly_public_key.status.fingerprint, "")
}

output "private_key_pem" {
  value     = tls_private_key.firefly_key.private_key_pem
  sensitive = true
}

output "integration_id" {
  value = module.firefly_nebius_integration.integration_id
}

output "status_code" {
  value = module.firefly_nebius_integration.status_code
}

output "response_body" {
  value = module.firefly_nebius_integration.response_body
}
