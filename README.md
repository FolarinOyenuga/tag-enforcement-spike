# Tag Enforcement Spike #540

**Objective:** Evaluate pre-deployment tag enforcement tools and recommend the best approach for MoJ.

**Ticket:** https://github.com/ministryofjustice/cloud-optimisation-and-accountability/issues/540

## Tools Under Evaluation


| tfsec | Static analysis | Pending |
| checkov | Static analysis | Pending |
| OPA/Conftest | Policy-as-code | Pending |
| terraform-tag-validator | Custom GH Action | Existing |

## Folder Structure

```
tag-enforcement-spike/
├── tfsec/              # tfsec config and notes
├── checkov/            # checkov config and notes
├── opa/                # OPA/Conftest policies
├── terraform-tag-validator/  # Reference to existing tool
├── test-terraform/     # Shared test fixtures
└── docs/               # Findings, comparison matrix
```

## Test Scenarios

All tools will be tested against the same Terraform files:
- `test-terraform/valid.tf` - All required tags present
- `test-terraform/invalid.tf` - Missing/invalid tags

## Required Tags (MoJ Standard)

- business-unit
- application
- owner
- is-production
- service-area
- environment-name

## Evaluation Criteria

1. **Ease of setup** - How quickly can teams adopt?
2. **Error clarity** - Are violations easy to understand/fix?
3. **Customization** - Can we enforce MoJ-specific rules?
4. **Maintenance** - How much ongoing effort?
5. **CI/CD integration** - Works with GitHub Actions?
6. **Cloud agnostic** - Extensible to Azure/GCP?

## Steps

- Research + light prototyping
- Testing + comparison
- Documentation + recommendation
