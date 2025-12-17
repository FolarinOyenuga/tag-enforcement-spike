variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
  validation {
    condition     = contains(["CICA", "Central Digital", "HMCTS", "HMPPS", "HQ", "LAA", "OPG", "Platforms", "Technology Services", "YJB"], var.business_unit)
    error_message = "business_unit must be one of: CICA, Central Digital, HMCTS, HMPPS, HQ, LAA, OPG, Platforms, Technology Services, YJB"
  }
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
}

variable "application" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Environment type"
  type        = string
  validation {
    condition     = contains(["staging", "production", "development", "test"], var.environment)
    error_message = "environment must be one of: staging, production, development, test"
  }
}

variable "owner" {
  description = "Team responsible for the service (format: team-name or team-name:email)"
  type        = string
}

variable "service_area" {
  description = "Service area within MoJ"
  type        = string
}

variable "is_production" {
  description = "Whether this is a production environment"
  type        = string
  default     = "false"
  validation {
    condition     = contains(["true", "false"], var.is_production)
    error_message = "is_production must be 'true' or 'false'"
  }
}
