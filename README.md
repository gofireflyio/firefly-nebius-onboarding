# Firefly Nebius Integration

This Terraform module automates the integration of Firefly with Nebius Cloud.

## Prerequisites

1. **Terraform** >= 1.5.0
2. **Nebius credentials** (service account with admin permissions)
3. **Firefly Credentials** (access key and secret key)
4. IAM admin permissions in your Nebius tenant

## Authentication

Choose one of the following authentication methods via `nebius_auth_method`:

### Option 1: Environment Variables (Default - Best for CI/CD)

```hcl
nebius_auth_method = "env"  # This is the default
```

Set these environment variables:
```bash
export NB_SA_ID=serviceaccount-xxxxxxxxxxxx
export NB_SA_PUBLIC_KEY_ID=publickey-xxxxxxxxxxxx
export NB_SA_PRIVATE_KEY_FILE=/path/to/private.pem
```

### Option 2: Service Account Variables

```hcl
nebius_auth_method        = "service_account"
nebius_service_account_id = "serviceaccount-xxxxxxxxxxxx"
nebius_public_key_id      = "publickey-xxxxxxxxxxxx"
nebius_private_key_file   = "/path/to/private.pem"
```

### Option 3: CLI Profile (Local Development)

```hcl
nebius_auth_method = "profile"
nebius_profile     = "myprofile"
```

> **Note:** CLI profile with federation auth requires browser interaction.

### Creating Admin Credentials

```bash
# Create service account with admin permissions
nebius iam service-account create --name admin-sa --parent-id <project-id>

# Get service account ID
export SA_ID=$(nebius iam service-account get-by-name --name admin-sa --format json | jq -r ".metadata.id")

# Add to admin group
nebius iam group-membership create --parent-id <admin-group-id> --member-id $SA_ID

# Generate authorized key (creates JSON with all credentials)
nebius iam auth-public-key generate --service-account-id $SA_ID --output ~/nebius-admin-key.json

# Set environment variables from generated JSON
export NB_SA_ID=$(cat ~/nebius-admin-key.json | jq -r '.["subject-credentials"].iss')
export NB_SA_PUBLIC_KEY_ID=$(cat ~/nebius-admin-key.json | jq -r '.["subject-credentials"].kid')
cat ~/nebius-admin-key.json | jq -r '.["subject-credentials"]["private-key"]' > ~/nebius-admin.pem
export NB_SA_PRIVATE_KEY_FILE=~/nebius-admin.pem
```

## Quick Start

```bash
# Clone repository
git clone https://github.com/gofireflyio/firefly-nebius-onboarding.git
cd firefly-nebius-onboarding

# Set environment variables (recommended)
export NB_SA_ID=serviceaccount-xxx
export NB_SA_PUBLIC_KEY_ID=publickey-xxx
export NB_SA_PRIVATE_KEY_FILE=~/nebius-admin-key.pem

# Create configuration
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Deploy
terraform init
terraform plan
terraform apply
```

## Configuration

### Required Variables

| Variable | Description |
|----------|-------------|
| `tenant_id` | Nebius Tenant ID |
| `project_id` | Nebius Project ID |
| `firefly_access_key` | Firefly access key |
| `firefly_secret_key` | Firefly secret key |

### Authentication Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `nebius_auth_method` | `"env"` | Auth method: `env`, `service_account`, or `profile` |
| `nebius_service_account_id` | `null` | Service account ID (for `service_account` method) |
| `nebius_public_key_id` | `null` | Public key ID (for `service_account` method) |
| `nebius_private_key_file` | `null` | Path to private key PEM (for `service_account` method) |
| `nebius_profile` | `null` | CLI profile name (for `profile` method) |

### Optional Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `integration_name` | Tenant name | Custom integration name |
| `prefix` | `""` | Prefix for created resource names |
| `suffix` | `""` | Suffix for created resource names |
| `existing_service_account_id` | `null` | Use existing service account for Firefly |
| `existing_group_id` | `null` | Use existing group for Firefly |
| `is_prod` | `true` | Mark integration as production |
| `enable_audit_logs` | `true` | Enable audit log permissions |
| `skip_integration_request` | `false` | Skip Firefly API request |

## Created Resources

- `nebius_iam_v1_service_account` - Service account for Firefly
- `nebius_iam_v1_group` - Group for permissions
- `nebius_iam_v1_group_membership` - Link service account to group
- `nebius_iam_v1_access_permit` - Viewer role on tenant
- `nebius_iam_v1_access_permit` - Audit log viewer (if `enable_audit_logs = true`)
- `nebius_iam_v1_access_permit` - Audit log exporter (if `enable_audit_logs = true`)
- `nebius_iam_v1_auth_public_key` - Public key for authentication

## Outputs

| Output | Description |
|--------|-------------|
| `integration_name` | Integration name used |
| `policy_version` | Policy version deployed |
| `service_account_id` | Created service account ID |
| `public_key_id` | Created public key ID |
| `fingerprint` | Public key fingerprint |
| `private_key_pem` | Private key (sensitive) |
| `integration_id` | Firefly integration ID |
| `status_code` | API response status code |
| `response_body` | API response body |

## Get IDs

```bash
# Get tenant ID
nebius iam tenant list

# Get project ID
nebius iam project list --parent-id <tenant-id>
```

## Support

For issues, contact Firefly support or open a GitHub issue.
