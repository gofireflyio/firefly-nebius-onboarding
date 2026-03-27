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
  # Authentication based on nebius_auth_method:
  # - "service_account": Direct credentials via variables
  # - "env": Credentials via environment variables (default, best for CI/CD)
  # - "profile": Nebius CLI profile (for local development)

  service_account = var.nebius_auth_method == "service_account" ? {
    account_id       = var.nebius_service_account_id
    public_key_id    = var.nebius_public_key_id
    private_key_file = var.nebius_private_key_file
  } : var.nebius_auth_method == "env" ? {
    account_id_env       = "NB_SA_ID"
    public_key_id_env    = "NB_SA_PUBLIC_KEY_ID"
    private_key_file_env = "NB_SA_PRIVATE_KEY_FILE"
  } : null

  profile = var.nebius_auth_method == "profile" ? {
    name = var.nebius_profile
  } : null

  parent_id = var.tenant_id
}
