# Tag Enforcement Spike Findings

**Related Issue:** [#540 - FIREBREAK: Investigate Automated Tag Enforcement Approaches](https://github.com/ministryofjustice/cloud-optimisation-and-accountability/issues/540)

---

## tfsec Findings Summary

### What works:
- Detects missing tag keys in provider default_tags
- Custom checks with aws_* wildcard for all AWS resources
- Provider-level enforcement (MoJ pattern)
- Docker container integration in GitHub Actions
- Clear error messages with file/line references

### Limitations:
- Cannot detect empty values (owner = "")
- Cannot detect whitespace-only values (owner = " ")
- Cannot validate value format (e.g., email regex)

**Root cause:** tfsec's matchSpec only supports `action: contains` which checks if a key exists in a map - it cannot access/validate the value.

---

## Checkov & tfsec Evaluation Summary

**Key finding:** Checkov can detect null and whitespace tag values; tfsec cannot.

**Shared limitation:** Neither tool reads variable values directly from .tf files - both require Terraform plan output.

### Resource-based plan scanning:

| Tool | Approach | Result |
|------|----------|--------|
| **Checkov** (`--framework terraform_plan`) | Plan-based | ✅ Resolves variables, detects empty/whitespace tags - matches terraform-tag-validator |
| **tfsec** (`--tfvars-file`) | Static | ❌ Still sees var references only, doesn't resolve values |

You can view the test steps on PR [#21](https://github.com/FolarinOyenuga/tag-enforcement-spike/pull/21) and [#22](https://github.com/FolarinOyenuga/tag-enforcement-spike/pull/22).

---

## Demo PRs

| PR | Purpose | Outcome |
|----|---------|---------|
| [#21](https://github.com/FolarinOyenuga/tag-enforcement-spike/pull/21) | Tag violations (missing, empty, whitespace, zero tags) | ❌ Blocked by ruleset |
| [#22](https://github.com/FolarinOyenuga/tag-enforcement-spike/pull/22) | Valid tags | ✅ Passed, mergeable |

---

## Repository Contents

```
tag-enforcement-spike/
├── .github/workflows/
│   ├── checkov-plan.yml      # Checkov plan-based scanning
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
