# tfsec Tag Enforcement

## Overview

tfsec is a static analysis tool for Terraform that supports custom checks via YAML configuration. This evaluation tests its ability to enforce MoJ tagging standards.

## Setup

1. Custom checks must be named `*_tfchecks.yaml`
2. Place in `.tfsec/` folder within the Terraform directory being scanned

## Files

- `moj_tfchecks.yaml` - MoJ tag enforcement custom checks (7 checks for required tags)

## Required Tags (MoJ Standard)

| Tag | Description |
|-----|-------------|
| `business-unit` | Area of MoJ responsible (CICA, Central Digital, HMCTS, HMPPS, HQ, LAA, OPG, Platforms, Technology Services, YJB) |
| `namespace` | Kubernetes namespace |
| `application` | Application name |
| `environment` | Environment type (staging, production, development, test) |
| `owner` | Team responsible for the service |
| `service-area` | Service area within MoJ |
| `is-production` | Whether production environment ("true" or "false") |

## Usage

```bash
# Scan with custom checks (auto-detected from .tfsec folder)
tfsec ./terraform-directory

# Using Docker container (recommended for CI)
docker run --rm -v "$(pwd):/src" aquasec/tfsec:latest /src
```

## Evaluation Findings

### What Works ✅

- Detects **missing tag keys** in provider `default_tags`
- Custom checks with `aws_*` wildcard for all AWS resources
- Provider-level enforcement (MoJ pattern using `default_tags`)
- Docker container integration in GitHub Actions
- Clear error messages with file/line references
- Easy YAML-based custom check configuration

### Limitations ❌

| Limitation | Details |
|------------|---------|
| Cannot detect empty values | `owner = ""` passes validation |
| Cannot detect whitespace-only values | `owner = "   "` passes validation |
| Cannot validate value format | No regex validation on tag values |
| Being deprecated | tfsec is joining Trivy family |

### Root Cause

tfsec's `matchSpec` only supports `action: contains` which checks if a **key exists** in a map - it cannot access or validate the **value**.

```yaml
# This only checks if 'owner' KEY exists, not its value
matchSpec:
  name: default_tags
  action: isPresent
  subMatch:
    name: tags
    action: contains
    value: owner
```

### regexMatches Investigation

Tested using `regexMatches` to validate tag values - **does not work**.
The action is designed for top-level string attributes (like `acl`, `source`),
not for values inside maps/objects like `tags`.

## Test Results

| Scenario | Result |
|----------|--------|
| Provider without `default_tags` | ✅ Caught - all tag checks fail |
| Provider with incomplete `default_tags` | ✅ Caught - missing tags detected |
| Provider with `owner = ""` (empty) | ❌ Not caught - key exists |
| Provider with whitespace-only values | ❌ Not caught - key exists |
| Valid provider with all tags | ✅ Passed |

## GitHub Actions Integration

See `.github/workflows/tfsec.yml` for CI integration.

The workflow:
1. Runs tfsec in Docker container
2. Copies custom checks to `.tfsec/` folder
3. Excludes built-in security checks (focus on tags)
4. Fails PR if missing tags detected

## Conclusion

**tfsec is suitable for:** Detecting missing tag keys at the provider level.

**tfsec is NOT suitable for:** Validating tag values (empty, whitespace, format).

**For 100% tagging compliance (key + value validation), consider:** checkov, OPA/Conftest, or custom tooling.
