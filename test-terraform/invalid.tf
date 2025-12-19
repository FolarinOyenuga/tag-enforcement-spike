# Invalid configurations to test tag enforcement tools
# These scenarios use variables but demonstrate common mistakes

# Scenario 1: Provider WITHOUT default_tags (missing tags entirely)
provider "aws" {
  alias                       = "no_default_tags"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"
  # Missing default_tags block entirely - should fail all tag checks
}

# Scenario 2: Provider with INCOMPLETE default_tags (missing some variables)
provider "aws" {
  alias                       = "incomplete_tags"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"

  default_tags {
    tags = {
      business-unit = var.business_unit
      application   = var.application
      owner         = ""  # Empty value - should fail
      # Missing: is-production, namespace, service-area, environment
    }
  }
}

# Scenario 3: Provider with ALL tags but using invalid variables (empty/whitespace values)
# Uses variables from variables-inv.tf to demonstrate empty/whitespace detection
provider "aws" {
  alias                       = "invalid_values"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"

  default_tags {
    tags = {
      business-unit = var.business_unit_invalid
      application   = var.application_invalid       # Whitespace only
      is-production = var.is_production_invalid
      owner         = var.owner_invalid             # Whitespace only
      namespace     = var.namespace_invalid         # Empty
      service-area  = var.service_area_invalid      # Empty
      environment   = var.environment_invalid
    }
  }
}

# Scenario 4: Resource using provider without default_tags
resource "aws_s3_bucket" "no_provider_tags" {
  provider = aws.no_default_tags
  bucket   = "moj-bucket-no-tags"

  tags = {
    business-unit = var.business_unit
    namespace     = var.namespace
    application   = var.application
    environment   = var.environment
    owner         = var.owner
    service-area  = var.service_area
    is-production = var.is_production
  }
}

# Scenario 5: Resource using provider with incomplete tags
resource "aws_dynamodb_table" "incomplete_provider_tags" {
  provider     = aws.incomplete_tags
  name         = "moj-table-incomplete"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    business-unit = var.business_unit
    namespace     = var.namespace
    application   = var.application
    environment   = var.environment
    owner         = var.owner
    service-area  = var.service_area
    is-production = var.is_production
  }
}

# Scenario 6: Resource using invalid variables provider (tests empty/whitespace detection)
resource "aws_sqs_queue" "invalid_values" {
  provider = aws.invalid_values
  name     = "moj-queue-invalid-vars"

  tags = {
    business-unit = var.business_unit
    namespace     = var.namespace
    application   = var.application
    environment   = var.environment
    owner         = var.owner
    service-area  = var.service_area
    is-production = var.is_production
  }
}

