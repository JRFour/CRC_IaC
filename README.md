# CRC_IaC
#### Terraform Infrastructure as Code for the Cloud Resume Challenge
*Please view the finished website [here](https://static.realewanderer.net)*
---

## Overview

This repository contains Terraform code that deploys:
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

## Quick Start

```bash
# Initialize Terraform
cd prod && terraform init

# Validate configuration
cd prod && terraform validate

# Create execution plan
cd prod && terraform plan -var="site_domain=example.com"

# Apply changes
cd prod && terraform apply -var="site_domain=example.com" -auto-approve
```

## CI/CD

| Workflow | Trigger | Description |
|----------|---------|-------------|
| `terraform-plan.yml` | Pull request | Runs `terraform plan` |
| `website-build.yml` | Push to main | Snyk scan + terraform apply |
| `terraform-destroy.yml` | Manual | Destroys infrastructure |

---

# Cloud Resume Challenge Checklist

- [X] Front-end
   - HTML / CSS
   - DNS / CDN
   - GitHub
   - DevOps Mod - Automation
   - Securty Mod - Spoofing
- [X] Back-end
   - DynamoDB
   - Python / AWS Lambda
   - AWS API
   - DevOps Mod - Monitoring & Notifications
   - Security Mod - IAM Privileges
- [ ] Front-end & Back-end Integration
   - Site & API connection
   - Playwright Smoke Tests
   - DevOps Mod - Browser Tests
   - Security Mod - Firewall
- [X] Automation / CI
   - [X] IaC
   - [ ] CI/CD Back-end
   - [ ] CI/CD Front-end
   - [ ] DevOps Mod - Staging Environment
   - [ ] Security Mod - Supply Chain Best Practices
