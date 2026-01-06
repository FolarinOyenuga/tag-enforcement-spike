# Spike Findings: Automated Tag Enforcement Approaches

**Related Issue:** [#540 - FIREBREAK: Investigate Automated Tag Enforcement Approaches](https://github.com/ministryofjustice/cloud-optimisation-and-accountability/issues/540)

**Date:** January 2026

**Author:** Folarin Oyenuga

---

## Executive Summary

This spike evaluated four approaches for pre-merge tag enforcement to achieve MoJ's 100% tagging compliance OKR. **terraform-tag-validator** is the recommended approach - it's purpose-built for MoJ, already tested, and offers the most complete feature set for tag enforcement.

**Key Finding:** Pre-merge enforcement (shift-left) is achievable with all viable tools. terraform-tag-validator can realistically pilot in Q1 2026 with immediate time-to-value.

---

## Tools Evaluated

| Tool | Approach | Verdict |
|------|----------|---------|
| **[terraform-tag-validator](https://github.com/ministryofjustice/terraform-tag-validator)** | Plan-based scanning | ✅ Recommended |
| **Checkov** | Plan-based scanning | ✅ Viable alternative |
| **OPA/Conftest** | Plan-based scanning | ⚠️ Viable but UX limitations |
| **tfsec** | Static analysis | ❌ Not suitable for tag validation |

---

## Comparison Matrix (Features, Effort, MoJ Fit)

| Capability | terraform-tag-validator | Checkov | OPA/Conftest | tfsec |
|------------|------------------------|---------|--------------|-------|
| **Plan-Based Scanning** | ✅ | ✅ | ✅ | ❌ |
| **Variable Resolution** | ✅ | ✅ | ✅ | ❌ |
| **Missing Tags Detection** | ✅ | ✅ | ✅ | ❌ |
| **Empty Value Detection** | ✅ | ✅ | ✅ | ❌ |
| **Whitespace Value Detection** | ✅ | ✅ | ✅ | ❌ |
| **Zero Tags Detection** | ✅ | ✅ | ✅ | ❌ |
| **File/Line Numbers** | ✅ | ✅ | ❌ | N/A |
| **Allowed Values Validation** | ✅ | ❌ | ❌ | ❌ |
| **Regex Pattern Validation** | ✅ | ❌ | ❌ | ❌ |
| **YAML Config Support** | ✅ | ❌ | ❌ | ✅ |
| **Resource Exclusion** | ✅ | ❌ | ❌ | ❌ |
| **MoJ Standards Built-in** | ✅ | ❌ | ❌ | ❌ |
| **Reusable GitHub Action** | ✅ | ✅ | ❌ | ❌ |
| **Cloud-Agnostic** | ⚠️ AWS | ⚠️ AWS | ✅ | ⚠️ AWS |
| **Setup Effort** | Low | Medium | Medium | Low |
| **Learning Curve** | Low | Low | Medium (Rego) | Low |

---

## Answers to Spike Questions

### 1. Which approach best balances enforcement strength, developer experience, and maintainability?

**terraform-tag-validator** provides the best balance:
- **Enforcement:** Catches all tag violations + validates allowed values and formats
- **Developer Experience:** Clear error messages with file/line numbers, MoJ standards built-in
- **Maintainability:** Python-based, YAML config for customization, already tested and documented

### 2. Can we achieve pre-merge blocking (shift-left)?

**Yes.** All viable tools (Checkov, OPA/Conftest, terraform-tag-validator) support pre-merge blocking via GitHub Actions workflows that:
1. Run `terraform plan` to resolve variables
2. Validate tags against MoJ requirements
3. Block PR merge on violations
4. Post detailed comments to PRs

### 3. What's the realistic time-to-value for each option?

| Tool | Time to Pilot | Notes |
|------|---------------|-------|
| **terraform-tag-validator** | Immediate | Already built, tested, published as GitHub Action |
| **Checkov** | 1-2 weeks | Custom policy needed, requires per-repo setup |
| **OPA/Conftest** | 2-3 weeks | Rego policy exists, but no file/line numbers |
| **tfsec** | N/A | Not viable - cannot resolve variables |

### 4. How do these tools handle MoJ-specific tag requirements?

All viable tools were configured with MoJ's required tags:
- `business-unit`
- `namespace`
- `application`
- `environment`
- `owner`
- `service-area`
- `is-production`

**terraform-tag-validator** additionally validates:
- Allowed values (e.g., `business-unit` must be HMPPS, OPG, LAA, etc.)
- Format patterns (e.g., `owner` must match `Team: email@domain.com`)
- Configurable via YAML without code changes

---

## Trade-offs and Learning Curves

| Tool | Trade-offs | Learning Curve |
|------|------------|----------------|
| **terraform-tag-validator** | AWS-focused (Azure/GCP would need extension) | Low - Python, simple workflow setup |
| **Checkov** | Requires custom policy per use case, no value validation | Low - Python, established docs |
| **OPA/Conftest** | No file/line numbers, requires Rego knowledge | Medium - Rego is declarative, unfamiliar to most |
| **tfsec** | Cannot resolve variables at all | Low - but irrelevant since not viable |

---

## Developer Experience Comparison

### Error Clarity

| Tool | Example Error Output | Clarity Rating |
|------|---------------------|----------------|
| **terraform-tag-validator** | `❌ aws_s3_bucket.example (main.tf:15)`<br>`Missing tags: owner, service-area` | ⭐⭐⭐⭐⭐ |
| **Checkov** | `Check: CKV_MOJ_001`<br>`File: main.tf:15-25`<br>`Missing: ['owner'], Empty: []` | ⭐⭐⭐⭐ |
| **OPA/Conftest** | `FAIL - Resource 'aws_s3_bucket.example' is missing required tags: ["owner"]` | ⭐⭐⭐ |
| **tfsec** | Shows `var.owner` not actual value | ⭐ |

### Fix Effort

| Tool | Developer Action Required |
|------|--------------------------|
| **terraform-tag-validator** | Go to file:line, add missing tag with valid value |
| **Checkov** | Go to file:line, add missing tag |
| **OPA/Conftest** | Search codebase for resource address, add missing tag |
| **tfsec** | N/A - cannot validate values |

---

## Q1 2026 Pilot Readiness

| Tool | Pilot Ready? | Rationale |
|------|--------------|-----------|
| **terraform-tag-validator** | ✅ Yes - Immediate | Already built, tested, published as GitHub Action |
| **Checkov** | ⚠️ Possible | Needs custom policy deployment, per-repo setup |
| **OPA/Conftest** | ❌ Not recommended | UX limitations would frustrate developers |
| **tfsec** | ❌ No | Not viable for tag validation |

---

## Assumptions Validation

| Assumption | Validated? | Notes |
|------------|------------|-------|
| Pre-merge enforcement is preferred over post-deploy detection | ✅ Yes | All viable tools support shift-left via GitHub Actions |
| MoJ tagging standards are the baseline requirements | ✅ Yes | terraform-tag-validator has MoJ standards built-in |

---

## Key Findings

### tfsec Cannot Resolve Variables

tfsec's `--tfvars-file` flag does **not** resolve Terraform variables. It only performs static analysis and shows variable references (e.g., `var.business_unit`) rather than actual values. This makes it unsuitable for tag value validation.

### Plan-Based Scanning is Essential

Static analysis alone cannot validate tag values because:
- Tags often reference variables
- Variables are resolved at `terraform plan` time
- Provider `default_tags` are merged during planning

### OPA/Conftest Lacks File/Line Numbers

OPA/Conftest processes the Terraform plan JSON which doesn't contain source file locations. This results in error messages that show resource addresses but not file/line numbers, making it harder for developers to locate issues.

## Recommendation

### Primary: terraform-tag-validator

**Rationale:**
1. **Purpose-built for MoJ** - Designed specifically for MoJ tagging standards
2. **Most complete feature set** - Validates allowed values, format patterns, resource exclusion
3. **Immediate time-to-value** - Already built, tested, and published as GitHub Action
4. **Best developer experience** - File/line numbers, clear error messages
5. **Low adoption barrier** - Simple workflow addition, YAML config for customization
6. **Maintainable** - Python-based, owned by COAT team

### Alternative: Checkov

If broader compliance scanning is needed beyond tagging (security, best practices), Checkov can run alongside terraform-tag-validator. However, for tag enforcement specifically, terraform-tag-validator is more complete.

### Not Recommended: OPA/Conftest

While functional, OPA/Conftest:
- Lacks file/line numbers in output (poor developer UX)
- Requires Rego knowledge (steeper learning curve)
- No built-in MoJ standards support

### Not Viable: tfsec

Cannot resolve Terraform variables - not suitable for tag value validation.

## Next Steps

1. **Pilot terraform-tag-validator** in 2-3 volunteer repositories
2. **Document rollout process** for teams
3. **Gather feedback** on developer experience
4. **Measure compliance improvement** over pilot period
5. **Scale to all repositories** based on pilot results
6. **Consider Checkov** for additional compliance checks (security, best practices)

## Repository Contents

This spike repository contains working implementations for all evaluated tools:

```
├── .github/workflows/
│   ├── checkov-plan.yml      # Checkov plan-based workflow
│   ├── checkov.yml           # Checkov static analysis
│   ├── opa-conftest.yml      # OPA/Conftest workflow
│   └── tfsec.yml             # tfsec workflow
├── checkov/policies/
│   └── moj_resource_tags.py  # Custom Checkov policy
├── opa/policy/
│   └── moj_tags.rego         # OPA Rego policy
├── tfsec/
│   └── moj_tfchecks.yaml     # tfsec custom checks
└── test-terraform/           # Test fixtures
```

## Demo

All workflows can be demonstrated via PR #13 which contains intentional tag violations:
- Missing tags
- Empty tag values
- Whitespace-only values
- Zero tags
- Valid tags (control)

---

## Definition of Done Checklist

| Requirement | Status | Evidence |
|-------------|--------|----------|
| Firebreak finding documented appropriately | ✅ | This document |
| Demo completed | ✅ | PR #13 demonstrates all tools |
| Decision made on whether to progress Firebreak work | ✅ | Yes - proceed with terraform-tag-validator |
| Does next steps require User Research? | ✅ | No - tool is ready for pilot |
| Firebreak next step Issues created | ⏳ | To be created after team review |
| New Issues referenced in this story before closure | ⏳ | Pending |
| Recommendation presented to team with rationale | ✅ | See Recommendation section |
| Comparison matrix completed (features, effort, MoJ fit) | ✅ | See Comparison Matrix section |

---

## Appendix: Test Evidence

### terraform-tag-validator
- Repository: https://github.com/ministryofjustice/terraform-tag-validator
- Published GitHub Action: `ministryofjustice/terraform-tag-validator@v1`
- Features tested: Missing tags, empty values, whitespace values, allowed values, format patterns

### Checkov
- Custom policy: `checkov/policies/moj_resource_tags.py`
- Workflow: `.github/workflows/checkov-plan.yml`
- Features tested: Plan-based scanning, missing tags, empty values

### OPA/Conftest
- Policy: `opa/policy/moj_tags.rego`
- Workflow: `.github/workflows/opa-conftest.yml`
- Features tested: Missing tags, empty values, whitespace values, zero tags
- Limitation confirmed: No file/line numbers in output

### tfsec
- Custom checks: `tfsec/moj_tfchecks.yaml`
- Workflow: `.github/workflows/tfsec.yml`
- Finding: `--tfvars-file` does NOT resolve variables - not viable
