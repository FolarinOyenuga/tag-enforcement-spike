# Tag Enforcement Tools Comparison Matrix

## Overview

| Criteria | tfsec | checkov | OPA/Conftest | terraform-tag-validator |
|----------|-------|---------|--------------|------------------------|
| **Setup Time** | ? | ? | ? | ✅ Ready |
| **Learning Curve** | ? | ? | ? | Low |
| **Error Clarity** | ? | ? | ? | ✅ File + line number |
| **Custom Rules** | ? | ? | ? | ✅ YAML config |
| **GH Actions** | ? | ? | ? | ✅ Native |
| **Cloud Agnostic** | ? | ? | ? | Terraform only |
| **Maintenance** | ? | ? | ? | Low |
| **Community** | ? | ? | ? | Internal |

## Detailed Evaluation

### tfsec

**Pros:**
- 

**Cons:**
- 

**Tag enforcement capability:**
- 

**Setup notes:**
- 

---

### checkov

**Pros:**
- 

**Cons:**
- 

**Tag enforcement capability:**
- 

**Setup notes:**
- 

---

### OPA/Conftest

**Pros:**
- 

**Cons:**
- 

**Tag enforcement capability:**
- 

**Setup notes:**
- 

---

### terraform-tag-validator (Custom)

**Pros:**
- Built for MoJ requirements
- Clear error messages with file/line
- YAML-based configuration
- Already working

**Cons:**
- Internal only (no community support)
- Requires maintenance

**Tag enforcement capability:**
- Full support for all MoJ required tags
- Regex validation for owner format
- Allowed values for business-unit, environment-name

---

## Recommendation

*To be completed after evaluation*

## Next Steps

*To be completed after evaluation*
