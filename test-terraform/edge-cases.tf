# Edge case tests for checkov CKV_MOJ_001 policy
# All tag values derived from variables-edge.tf

# Edge Case 1: All tags present with valid values (should PASS)
provider "aws" {
  alias                       = "all_tags_valid"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"

  default_tags {
    tags = {
      business-unit = var.ec1_business_unit
      namespace     = var.ec1_namespace
      application   = var.ec1_application
      environment   = var.ec1_environment
      owner         = var.ec1_owner
      service-area  = var.ec1_service_area
      is-production = var.ec1_is_production
    }
  }
}

# Edge Case 2: Whitespace-only values (should FAIL)
provider "aws" {
  alias                       = "whitespace_values"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"

  default_tags {
    tags = {
      business-unit = var.ec2_business_unit  # Whitespace only
      namespace     = var.ec2_namespace      # Whitespace only
      application   = var.ec2_application    # Single space
      environment   = var.ec2_environment
      owner         = var.ec2_owner
      service-area  = var.ec2_service_area
      is-production = var.ec2_is_production
    }
  }
}

# Edge Case 3: Empty default_tags block (should FAIL)
provider "aws" {
  alias                       = "empty_default_tags"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"

  default_tags {
    tags = {}
  }
}

# Edge Case 4: Mixed - some empty, some valid (should FAIL)
provider "aws" {
  alias                       = "mixed_values"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"

  default_tags {
    tags = {
      business-unit = var.ec4_business_unit
      namespace     = var.ec4_namespace      # Empty
      application   = var.ec4_application
      environment   = var.ec4_environment    # Whitespace
      owner         = var.ec4_owner
      service-area  = var.ec4_service_area   # Empty
      is-production = var.ec4_is_production
    }
  }
}

# Edge Case 5: Extra tags but missing required ones (should FAIL)
provider "aws" {
  alias                       = "extra_but_missing"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"

  default_tags {
    tags = {
      business-unit = var.ec5_business_unit
      application   = var.ec5_application
      owner         = var.ec5_owner
      custom-tag    = var.ec5_custom_tag
      another-tag   = var.ec5_another_tag
      # Missing: namespace, environment, service-area, is-production
    }
  }
}

# Edge Case 6: Null-like string values (should PASS - they are valid strings)
provider "aws" {
  alias                       = "null_like_values"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"

  default_tags {
    tags = {
      business-unit = var.ec6_business_unit
      namespace     = var.ec6_namespace      # String "null"
      application   = var.ec6_application    # String "undefined"
      environment   = var.ec6_environment    # String "none"
      owner         = var.ec6_owner
      service-area  = var.ec6_service_area
      is-production = var.ec6_is_production
    }
  }
}
