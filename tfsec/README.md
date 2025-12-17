# tfsec Tag Enforcement

## Setup

1. Custom checks must be named `*_tfchecks.yaml`
2. Place in `.tfsec/` folder within the Terraform directory being scanned

## Files

- `moj_tfchecks.yaml` - MoJ tag enforcement custom checks (6 checks for 6 required tags)

## Usage

```bash
# Scan with custom checks (auto-detected from .tfsec folder)
tfsec ./terraform-directory

# Or specify custom check directory explicitly
tfsec --custom-check-dir ./tfsec ./terraform-directory
```

## Findings

### Pros
- Easy YAML-based custom checks
- Good error messages with file/line references
- Also catches security issues (bonus)
- GitHub Actions available

### Cons
- File naming convention is strict (`*_tfchecks.yaml`)
- Must list each resource type explicitly (no wildcards)
- Being deprecated in favor of Trivy
- Cannot validate tag VALUES (only presence)

### Limitations Discovered
- `action: contains` only checks if tag KEY exists in map
- `regexMatches` works on string attributes, NOT map values
- Cannot access `tags["business-unit"]` value for validation
- Cannot enforce `business-unit` must be in allowed list
- Cannot enforce `owner` format with regex
- Cannot detect empty string `""` or whitespace `"   "` tag values
- For value validation, need OPA, checkov, or custom tool

### regexMatches Investigation
Tested using `regexMatches` to validate tag values - **does not work**.
The action is designed for top-level string attributes (like `acl`, `source`),
not for values inside maps/objects like `tags`.

## Test Results

```
invalid.tf resources:
- missing_tags: Caught (missing 4 tags)
- empty_tags: NOT caught (empty value not detected)
- wrong_values: NOT caught (invalid values not detected)
- whitespace_tags: NOT caught (whitespace-only values not detected)
- no_tags: Caught (missing all 6 tags)

valid.tf resources:
- All passed tag checks ✅
```

## Empty/Whitespace Value Detection

| Test Case | tfsec Result |
|-----------|--------------|
| `application = ""` | ❌ Not caught |
| `business-unit = "   "` | ❌ Not caught |
| `service-area = " "` | ❌ Not caught |

**tfsec cannot detect empty or whitespace-only tag values.**

## GitHub Actions

See `.github/workflows/tfsec.yml` for CI integration.

The workflow:
1. Copies custom checks to `.tfsec/` folder
2. Runs tfsec with built-in security checks excluded
3. Fails PR if missing tags detected
