# Valid variables - all tags have proper values
# Used with valid.tf to demonstrate compliant configuration

variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
  default     = "Platforms"
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "tag-enforcement-spike-dev"
}

variable "application" {
  description = "Name of the application"
  type        = string
  default     = "Tag Enforcement Spike"
}

variable "environment" {
  description = "Environment type"
  type        = string
  default     = "development"
}

variable "owner" {
  description = "Team responsible for the service"
  type        = string
  default     = "coat-team"
}

variable "service_area" {
  description = "Service area within MoJ"
  type        = string
  default     = "Cloud Optimisation"
}

variable "is_production" {
  description = "Whether this is a production environment"
  type        = string
  default     = "false"
}
