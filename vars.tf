variable "nebius_profile" {
  type        = string
  description = "Nebius CLI profile name"
  default     = null
}

variable "tenant_id" {
  type        = string
  description = "Nebius Tenant ID"
  validation {
    condition     = var.tenant_id != ""
    error_message = "Variable \"tenant_id\" cannot be empty."
  }
}

variable "project_id" {
  type        = string
  description = "Nebius Project ID where service account will be created"
  validation {
    condition     = var.project_id != ""
    error_message = "Variable \"project_id\" cannot be empty."
  }
}

variable "firefly_endpoint" {
  type    = string
  default = "https://prodapi.firefly.ai/api"
}

variable "firefly_access_key" {
  sensitive   = true
  type        = string
  description = "Your Firefly authentication access_key"
  validation {
    condition     = var.firefly_access_key != ""
    error_message = "Variable \"firefly_access_key\" cannot be empty."
  }
}

variable "firefly_secret_key" {
  sensitive   = true
  type        = string
  description = "Your Firefly authentication secret_key"
  validation {
    condition     = var.firefly_secret_key != ""
    error_message = "Variable \"firefly_secret_key\" cannot be empty."
  }
}

variable "prefix" {
  type        = string
  description = "Prefix for created resource names"
  default     = ""
}

variable "suffix" {
  type        = string
  description = "Suffix for created resource names"
  default     = ""
}

variable "existing_service_account_id" {
  type        = string
  description = "ID of existing service account to use"
  default     = null
}

variable "existing_group_id" {
  type        = string
  description = "ID of existing group to use"
  default     = null
}

variable "integration_name" {
  type        = string
  description = "Integration name (defaults to tenant name from Nebius)"
  default     = ""
}

variable "is_prod" {
  type        = bool
  description = "Mark integration as production environment"
  default     = true
}

variable "enable_audit_logs" {
  type        = bool
  description = "Enable audit log permissions for event-driven integration"
  default     = true
}

variable "skip_integration_request" {
  type        = bool
  description = "Skip the HTTP integration request to Firefly API"
  default     = false
}
