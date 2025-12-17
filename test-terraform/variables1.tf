# Invalid variables - some tags have empty/whitespace values
# Used with invalid.tf to demonstrate non-compliant configuration

variable "business_unit_invalid" {
  description = "Area of the MOJ responsible for the service"
  type        = string
  default     = "Platforms"
}

variable "namespace_invalid" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = ""  # Empty - should fail
}

variable "application_invalid" {
  description = "Name of the application"
  type        = string
  default     = "  "  # Whitespace only - should fail
}

variable "environment_invalid" {
  description = "Environment type"
  type        = string
  default     = "development"
}

variable "owner_invalid" {
  description = "Team responsible for the service"
  type        = string
  default     = "   "  # Whitespace only - should fail
}

variable "service_area_invalid" {
  description = "Service area within MoJ"
  type        = string
  default     = ""  # Empty - should fail
}

variable "is_production_invalid" {
  description = "Whether this is a production environment"
  type        = string
  default     = "false"
}
