# checkov Tag Enforcement

## Overview

checkov is a static code analysis tool for infrastructure-as-code that supports custom policies via Python or YAML. This evaluation tests its ability to enforce MoJ tagging standards.

## Setup

1. Custom policies go in the `checkov/policies/` folder
2. Run checkov with `--external-checks-dir` pointing to the policies folder

## Files

- `policies/` - Custom MoJ tag enforcement policies

## Required Tags (MoJ Standard)

| Tag | Description |
|-----|-------------|
| `business-unit` | Area of MoJ responsible |
| `namespace` | Kubernetes namespace |
| `application` | Application name |
| `environment` | Environment type |
| `owner` | Team responsible for the service |
| `service-area` | Service area within MoJ |
| `is-production` | Whether production environment |

## Usage

```bash
# Install checkov
pip install checkov

# Run with custom policies
checkov -d ./terraform-directory --external-checks-dir ./checkov/policies

# Using Docker
docker run --rm -v "$(pwd):/src" bridgecrew/checkov -d /src/test-terraform --external-checks-dir /src/checkov/policies
```

## Evaluation Findings

*To be completed after testing*

## GitHub Actions Integration

See `.github/workflows/checkov.yml` for CI integration.
