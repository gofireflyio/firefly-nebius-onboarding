# Firefly Nebius Integration

This Terraform module automates the integration of Firefly with Nebius Cloud.

## Prerequisites

1. **Terraform** >= 1.5.0
2. **Nebius CLI** configured (`nebius profile create`)
3. **Firefly Credentials** (access key and secret key)
4. IAM admin permissions in your Nebius tenant

## Quick Start

```bash
# Clone repository
git clone https://github.com/gofireflyio/firefly-nebius-onboarding.git
cd firefly-nebius-onboarding

# Create configuration
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Deploy
terraform init
terraform plan
terraform apply
```

## Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `tenant_id` | Yes | - | Nebius Tenant ID |
| `project_id` | Yes | - | Nebius Project ID |
| `firefly_access_key` | Yes | - | Firefly access key |
| `firefly_secret_key` | Yes | - | Firefly secret key |
| `nebius_profile` | No | `null` | Nebius CLI profile name |
| `integration_name` | No | Tenant name | Custom integration name |
| `prefix` | No | `""` | Prefix for created resource names |
| `suffix` | No | `""` | Suffix for created resource names |
| `existing_service_account_id` | No | `null` | Use existing service account |
| `existing_group_id` | No | `null` | Use existing group |
| `is_prod` | No | `true` | Mark integration as production |
| `enable_audit_logs` | No | `true` | Enable audit log permissions |
| `skip_integration_request` | No | `false` | Skip Firefly API request |

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
