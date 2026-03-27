terraform {
  required_version = ">= 1.5.0"
  required_providers {
    nebius = {
      source  = "terraform-provider.storage.eu-north1.nebius.cloud/nebius/nebius"
      version = ">= 0.5.55"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }
}

provider "nebius" {
  profile = var.nebius_profile != null ? {
    name = var.nebius_profile
  } : null
  parent_id = var.tenant_id
}
