variable "business_unit" {
  description = "MoJ Business Unit"
  type        = string
  default     = "Platforms"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "cloud-platform"
}

variable "application" {
  description = "Application name"
  type        = string
  default     = "Tag Enforcement Demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "owner" {
  description = "Team responsible"
  type        = string
  default     = "COAT: cloud-optimisation@digital.justice.gov.uk"
}

variable "service_area" {
  description = "Service area"
  type        = string
  default     = "Cloud Optimisation"
}

variable "is_production" {
  description = "Is production environment"
  type        = string
  default     = "false"
}

variable "empty_value" {
  description = "Empty string for testing"
  type        = string
  default     = ""
}

variable "whitespace_value" {
  description = "Whitespace-only for testing"
  type        = string
  default     = "   "
}
