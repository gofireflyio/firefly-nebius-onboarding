output "status_code" {
  value = var.skip_integration_request ? 0 : try(data.http.firefly_nebius_integration_request[0].status_code, 0)
}

output "response_body" {
  value = var.skip_integration_request ? "{}" : try(data.http.firefly_nebius_integration_request[0].response_body, "{}")
}

output "integration_id" {
  value = local.integration_id
}
