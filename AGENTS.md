# AGENTS.md - Agentic Coding Guidelines

This document provides guidelines for agents operating in this repository.

## Project Overview

This is a Terraform-based Infrastructure as Code (IaC) project for the Cloud Resume Challenge. It deploys:
- AWS S3 static website hosting
- CloudFront CDN distribution
- AWS ACM SSL certificates
- Cloudflare DNS records

## Directory Structure

```
.
├── prod/                    # Production Terraform configuration
│   ├── main.tf             # Core infrastructure (S3, CloudFront, ACM)
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Output values
│   ├── provider.tf         # Provider configuration
│   ├── backend.tf          # Remote state (S3)
│   └── cloudflare.tf       # DNS records
├── .github/
│   └── workflows/          # CI/CD pipelines
└── README.md
```

## Build/Lint/Test Commands

### Terraform Commands

```bash
# Initialize Terraform (required before plan/apply)
cd prod && terraform init

# Validate configuration syntax
cd prod && terraform validate

# Create execution plan
cd prod && terraform plan -var="site_domain=example.com"

# Apply changes (auto-approve for CI)
cd prod && terraform apply -var="site_domain=example.com" -auto-approve

# Destroy infrastructure
cd prod && terraform destroy --auto-approve

# Format code
cd prod && terraform fmt -recursive
```

### Running a Single Test

This project uses GitHub Actions for CI:
- **terraform-plan.yml**: Runs on pull requests
- **terraform-destroy.yml**: Manual workflow dispatch
- **website-build.yml**: Runs on push to main (includes Snyk)

Run `terraform validate` locally as a single test:
```bash
cd prod && terraform validate
```

### Security Scanning

Snyk IaC scanning runs in CI via `website-build.yml`:
```bash
snyk iac test --report
```

## Code Style Guidelines

### General Principles

1. **Use Terraform modules** for reusable components
2. **Always use variables** for configuration that may change between environments
3. **Use `depends_on`** explicitly when dependencies are not implicit
4. **Use `locals`** for computed values and to reduce repetition
5. **Include descriptions** on all variables and outputs

### Formatting

- Use 2 spaces for indentation
- Run `terraform fmt -recursive` before committing
- Align resource arguments for readability
- Use blank lines to separate logical resource groups

### Naming Conventions

- **Resources**: snake_case (e.g., `aws_s3_bucket`, `cloudflare_record`)
- **Variables**: snake_case (e.g., `aws_region`, `site_domain`)
- **Outputs**: snake_case with descriptive names
- **Tags**: TitleCase (e.g., `Project`, `Environment`)

### Resource Ordering

1. Provider configuration
2. Data sources
3. Resource definitions
4. Locals
5. Outputs

### Error Handling

- Use `lifecycle` blocks for create_before_destroy, prevent_destroy
- Use `continue-on-error: true` in GitHub Actions for non-critical steps
- Handle conditional creation with `count` or `for_each`

### Security Best Practices

1. **Never commit secrets**: Use environment variables or GitHub Secrets
2. **Use Terraform variables** for sensitive values, not hardcoded
3. **Remote state**: State stored in S3 (configured in `backend.tf`)
4. **CAA records**: Include CAA records for certificate authorization
5. **Least privilege**: Use IAM policies with minimal required permissions

### GitHub Actions Workflows

- Workflows run from `prod/` directory (set via `defaults.run.working-directory`)
- AWS credentials passed via secrets
- Cloudflare token passed via secrets
- Snyk token for security scanning
- Always use `continue-on-error: true` for plan steps

### Variable Definitions

Always define variables with type and description:
```hcl
variable "site_domain" {
  type        = string
  description = "The domain name to use for the static site"
}
```

### Output Definitions

Always define outputs with descriptions:
```hcl
output "cloudfront_url" {
  description = "CloudFront endpoint"
  value       = aws_cloudfront_distribution.site_distribution.domain_name
}
```

## Environment-Specific Notes

- **Production**: Uses `prod/` directory with S3 remote state bucket `00terrstate`
- **Domain**: Currently configured for `static.realewanderer.net`
- **AWS Region**: Default is `us-east-1`
- **Cloudflare Zone ID**: Defined as variable `cloudflare_zone_id` in `cloudflare.tf` (default: 3a7f62044f83e2a88fc3fddb3d90ca31)

## CI/CD Pipeline Flow

1. **Pull Request**: `terraform-plan.yml` runs `terraform plan`
2. **Push to Main**: `website-build.yml` runs Snyk scan, terraform plan, then apply
