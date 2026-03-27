variable "firefly_endpoint" {
  type    = string
  default = "https://prodapi.firefly.ai/api"
}

variable "firefly_token" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type = string
}

variable "integration_name" {
  type = string
}

variable "service_account_id" {
  type = string
}

variable "public_key_id" {
  type = string
}

variable "private_key_pem" {
  type      = string
  sensitive = true
}

variable "is_prod" {
  type    = bool
  default = true
}

variable "skip_integration_request" {
  type    = bool
  default = false
}

variable "policy_version" {
  type        = string
  description = "Version of the access policy being deployed"
  default     = "1.0.0"
}
