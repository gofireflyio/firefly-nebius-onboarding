# Firefly Nebius Integration

Terraform module to integrate your Nebius Cloud environment with [Firefly](https://firefly.ai).

## Prerequisites

- **Terraform** >= 1.5.0
- **Nebius CLI** installed and configured
- **Firefly Credentials** (access key and secret key from Firefly console)
- IAM admin permissions in your Nebius tenant

## Usage

```hcl
module "firefly_nebius_onboarding" {
  source = "github.com/gofireflyio/firefly-nebius-onboarding?ref=main"

  # Required
  tenant_id          = "tenant-xxxxxxxxxxxx"
  project_id         = "project-xxxxxxxxxxxx"
  firefly_access_key = var.firefly_access_key
  firefly_secret_key = var.firefly_secret_key

  # Nebius Authentication - choose one method:

  # Option 1: Environment variables (default, recommended for CI/CD)
  # Set: NB_SA_ID, NB_SA_PUBLIC_KEY_ID, NB_SA_PRIVATE_KEY_FILE
  nebius_auth_method = "env"

  # Option 2: Direct credentials
  # nebius_auth_method        = "service_account"
  # nebius_service_account_id = "serviceaccount-xxxxxxxxxxxx"
  # nebius_public_key_id      = "publickey-xxxxxxxxxxxx"
  # nebius_private_key_file   = "/path/to/private.pem"

  # Option 3: CLI profile (local development)
  # nebius_auth_method = "profile"
  # nebius_profile     = "myprofile"

  # Optional
  # integration_name  = "Nebius Integration" #(Default: Tenant name)
  # is_prod           = true
  # enable_audit_logs = true
}
```

## Creating Nebius Admin Credentials

```bash
# Create service account with admin permissions
nebius iam service-account create --name firefly-admin-sa --parent-id <project-id>

# Get service account ID
export SA_ID=$(nebius iam service-account get-by-name --name firefly-admin-sa --format json | jq -r ".metadata.id")

# Add to admin group
nebius iam group-membership create --parent-id <admin-group-id> --member-id $SA_ID

# Generate authorized key
nebius iam auth-public-key generate --service-account-id $SA_ID --output ~/nebius-admin-key.json

# Extract credentials for environment variables
export NB_SA_ID=$(cat ~/nebius-admin-key.json | jq -r '.["subject-credentials"].iss')
export NB_SA_PUBLIC_KEY_ID=$(cat ~/nebius-admin-key.json | jq -r '.["subject-credentials"].kid')
cat ~/nebius-admin-key.json | jq -r '.["subject-credentials"]["private-key"]' > ~/nebius-admin.pem
export NB_SA_PRIVATE_KEY_FILE=~/nebius-admin.pem
```

## Getting Your IDs

```bash
# Get tenant ID
nebius iam tenant list

# Get project ID
nebius iam project list --parent-id <tenant-id>
```

## Variables

### Required

| Variable             | Description        |
| -------------------- | ------------------ |
| `tenant_id`          | Nebius Tenant ID   |
| `project_id`         | Nebius Project ID  |
| `firefly_access_key` | Firefly access key |
| `firefly_secret_key` | Firefly secret key |

### Optional

| Variable                      | Default     | Description                                          |
| ----------------------------- | ----------- | ---------------------------------------------------- |
| `integration_name`            | Tenant name | Custom integration name in Firefly                   |
| `prefix`                      | `""`        | Prefix for created resource names                    |
| `suffix`                      | `""`        | Suffix for created resource names                    |
| `existing_service_account_id` | `null`      | Use existing service account instead of creating new |
| `existing_group_id`           | `null`      | Use existing group instead of creating new           |
| `is_prod`                     | `true`      | Mark integration as production environment           |
| `enable_audit_logs`           | `true`      | Enable audit log permissions for event-driven        |
| `skip_integration_request`    | `false`     | Skip Firefly API registration (for testing)          |

## Resources Created

This module creates the following resources in your Nebius tenant:

| Resource         | Description                                                        |
| ---------------- | ------------------------------------------------------------------ |
| Service Account  | `firefly-integration` - Used by Firefly to access your environment |
| Group            | `firefly-group` - Contains the service account                     |
| Group Membership | Links service account to group                                     |
| Access Permit    | `viewer` role on tenant for inventory discovery                    |
| Access Permit    | `audit-log.viewer` for event-driven (if enabled)                   |
| Access Permit    | `audit-log.exporter` for event-driven (if enabled)                 |
| Auth Public Key  | RSA key pair for service account authentication                    |

## Outputs

| Output               | Description                                               |
| -------------------- | --------------------------------------------------------- |
| `integration_name`   | Integration name registered in Firefly                    |
| `integration_id`     | Firefly integration ID                                    |
| `policy_version`     | Policy version deployed (for tracking permission changes) |
| `service_account_id` | Created service account ID                                |
| `public_key_id`      | Created public key ID                                     |
| `fingerprint`        | Public key fingerprint                                    |
| `private_key_pem`    | Private key PEM (sensitive)                               |

## Policy Evolution

The module uses versioned policies (`policy_version` output) to track permission changes over time. When Firefly requires additional permissions in the future, you can update the module version and re-apply to get the new policy.

## Support

- [Firefly Documentation](https://docs.firefly.ai)
- [Open GitHub Issue](https://github.com/gofireflyio/firefly-nebius-onboarding/issues)
- Contact Firefly support
