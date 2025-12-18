# Edge case variables for testing checkov CKV_MOJ_001 policy

# === Edge Case 1: All valid values ===
variable "ec1_business_unit" {
  type    = string
  default = "Platforms"
}

variable "ec1_namespace" {
  type    = string
  default = "tag-enforcement-spike"
}

variable "ec1_application" {
  type    = string
  default = "Tag Enforcement Spike"
}

variable "ec1_environment" {
  type    = string
  default = "development"
}

variable "ec1_owner" {
  type    = string
  default = "coat-team"
}

variable "ec1_service_area" {
  type    = string
  default = "Cloud Optimisation"
}

variable "ec1_is_production" {
  type    = string
  default = "false"
}

# === Edge Case 2: Whitespace-only values ===
variable "ec2_business_unit" {
  type    = string
  default = "   "  # Whitespace only
}

variable "ec2_namespace" {
  type    = string
  default = "  "  # Whitespace only
}

variable "ec2_application" {
  type    = string
  default = " "  # Single space
}

variable "ec2_environment" {
  type    = string
  default = "development"
}

variable "ec2_owner" {
  type    = string
  default = "coat-team"
}

variable "ec2_service_area" {
  type    = string
  default = "Cloud Optimisation"
}

variable "ec2_is_production" {
  type    = string
  default = "false"
}

# === Edge Case 4: Mixed empty and valid ===
variable "ec4_business_unit" {
  type    = string
  default = "Platforms"
}

variable "ec4_namespace" {
  type    = string
  default = ""  # Empty
}

variable "ec4_application" {
  type    = string
  default = "Tag Enforcement Spike"
}

variable "ec4_environment" {
  type    = string
  default = "   "  # Whitespace
}

variable "ec4_owner" {
  type    = string
  default = "coat-team"
}

variable "ec4_service_area" {
  type    = string
  default = ""  # Empty
}

variable "ec4_is_production" {
  type    = string
  default = "false"
}

# === Edge Case 5: Extra tags but missing required ===
variable "ec5_business_unit" {
  type    = string
  default = "Platforms"
}

variable "ec5_application" {
  type    = string
  default = "Tag Enforcement Spike"
}

variable "ec5_owner" {
  type    = string
  default = "coat-team"
}

variable "ec5_custom_tag" {
  type    = string
  default = "custom-value"
}

variable "ec5_another_tag" {
  type    = string
  default = "another-value"
}

# === Edge Case 6: Null-like string values (should pass) ===
variable "ec6_business_unit" {
  type    = string
  default = "Platforms"
}

variable "ec6_namespace" {
  type    = string
  default = "null"  # String "null" - valid value
}

variable "ec6_application" {
  type    = string
  default = "undefined"  # String "undefined" - valid value
}

variable "ec6_environment" {
  type    = string
  default = "none"  # String "none" - valid value
}

variable "ec6_owner" {
  type    = string
  default = "coat-team"
}

variable "ec6_service_area" {
  type    = string
  default = "Cloud Optimisation"
}

variable "ec6_is_production" {
  type    = string
  default = "false"
}
