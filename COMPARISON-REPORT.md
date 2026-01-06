## Comparison Report: OPA vs Checkov vs terraform-tag-validator

### Overview

| Criteria | terraform-tag-validator | Checkov | OPA/Conftest |
|----------|------------------------|---------|--------------|
| **Primary Purpose** | MoJ tag enforcement | General compliance scanning | General policy engine |
| **Language** | Python | Python | Rego |
| **Deployment** | GitHub Action | GitHub Action / CLI | Docker + CLI |

---

### terraform-tag-validator

**Pros:**
- ✅ Purpose-built for MoJ - Default config matches MoJ tagging standards exactly
- ✅ Value validation - Validates allowed values (e.g., business-unit must be HMPPS/OPG/LAA)
- ✅ Format validation - Regex patterns (e.g., owner must be `Team: email@domain.com`)
- ✅ File/line numbers - Parses .tf files to show exact location
- ✅ Resource exclusion - Can exclude auto-created resources via wildcards
- ✅ YAML config - Update standards without code changes
- ✅ Immediate deployment - Published GitHub Action, ready to use
- ✅ Low learning curve - Python-based, familiar to team

**Cons:**
- ⚠️ AWS-focused - Would need extension for Azure/GCP
- ⚠️ Single purpose - Only does tag validation, not broader compliance
- ⚠️ Smaller community - Internal tool, less external support and requires internal maintenance

---

### Checkov

**Pros:**
- ✅ Broad ecosystem - 1000+ built-in checks (security, compliance, best practices)
- ✅ Plan-based scanning - Resolves variables via `--framework terraform_plan`
- ✅ File/line numbers - Shows exact source location
- ✅ Active community - Well-documented, regularly updated
- ✅ Multi-cloud - Supports AWS, Azure, GCP, Kubernetes
- ✅ Extensible - Custom Python policies
- ✅ It can validate tag values

**Cons:**
- ❌ No format validation - Cannot enforce regex patterns (e.g., owner email)
- ⚠️ Custom policy required - MoJ standards not built-in, need to write and maintain
- ⚠️ More setup - Requires custom policy deployment per repo
- ⚠️ Noisy - Many built-in checks may not be relevant, requires tuning to be fit for purpose

---

### OPA/Conftest

**Pros:**
- ✅ Cloud-agnostic - Works with any JSON/YAML input
- ✅ Most flexible - Rego can express complex logic
- ✅ Policy-as-code - Centralised policy management
- ✅ Lightweight - Single binary, fast execution
- ✅ Reusable - Same policy engine for K8s, Terraform, etc.

**Cons:**
- ❌ No file/line numbers - Plan JSON lacks source location, poor developer UX
- ❌ Rego learning curve - Declarative language unfamiliar to most devs
- ❌ No built-in standards - Must write everything from scratch
- ⚠️ Debugging difficulty - Rego errors can be cryptic and unhelpful
- ⚠️ Technically OPA/Rego can do value validation, it just requires extra work

---

### Feature Comparison

| Capability | terraform-tag-validator | Checkov | OPA/Conftest |
|------------|------------------------|---------|--------------|
| Plan-Based Scanning | ✅ | ✅ | ✅ |
| Variable Resolution | ✅ | ✅ | ✅ |
| Missing Tags Detection | ✅ | ✅ | ✅ |
| Empty/Whitespace Detection | ✅ | ✅ | ✅ |
| File/Line Numbers | ✅ | ✅ | ❌ |
| Allowed Values Validation | ✅ | ❌ | ❌ |
| Regex Pattern Validation | ✅ | ❌ | ❌ |
| MoJ Standards Built-in | ✅ | ❌ | ❌ |
| Resource Exclusion | ✅ | ❌ | ❌ |
| Cloud-Agnostic | ⚠️ AWS | ⚠️ AWS | ✅ |
| Learning Curve | Low | Low | Medium |
| Q1 2026 Pilot Ready | Feasible | Feasible | Feasible |

---

### Summary: Key Trade-offs for Team Discussion

| Tool | Strengths | Considerations |
|------|-----------|----------------|
| **terraform-tag-validator** | Ready now, MoJ standards built-in, best developer UX, validates values/formats | AWS-only, smaller community, requires internal maintenance |
| **Checkov** | Large ecosystem, active community, multi-cloud, extensible | Needs custom policy, no value/format validation, more setup |
| **OPA/Conftest** | Cloud-agnostic, flexible, reusable across tools | Poor developer UX (no file/line numbers), Rego learning curve |

### Decision Points for the Team

1. **Immediate vs Long-term:** Do we prioritise immediate deployment or invest in a tool with broader community support?
2. **Maintenance:** Are we comfortable maintaining an internal tool, or prefer leveraging established open-source projects?
3. **Multi-cloud:** How important is Azure/GCP support immediately and in the near term?

All three viable tools achieve the core requirement of pre-merge tag enforcement. The choice depends on team priorities around maintenance burden, feature depth, and future extensibility.
