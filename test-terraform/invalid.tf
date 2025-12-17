terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "test"
  secret_key                  = "test"
}

# Invalid: Missing required tags
resource "aws_s3_bucket" "missing_tags" {
  bucket = "moj-invalid-bucket"

  tags = {
    business-unit = "Platforms"
    application   = "Some App"
    # Missing: owner, is-production, service-area, environment-name
  }
}

# Invalid: Empty tag values
resource "aws_instance" "empty_tags" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    business-unit    = "Platforms"
    application      = ""  # Empty value
    owner            = "COAT Team: coat@digital.justice.gov.uk"
    is-production    = "false"
    service-area     = "Cloud Optimisation"
    environment-name = "test"
  }
}

# Invalid: Wrong tag values
resource "aws_rds_cluster" "wrong_values" {
  cluster_identifier = "moj-invalid-rds"
  engine             = "aurora-mysql"

  tags = {
    business-unit    = "InvalidUnit"  # Not in allowed list
    application      = "Tag Enforcement Spike"
    owner            = "no-email-here"  # Wrong format
    is-production    = "maybe"  # Should be true/false
    service-area     = "Cloud Optimisation"
    environment-name = "prod"  # Should be 'production'
  }
}

# Invalid: Whitespace-only tag values
resource "aws_lambda_function" "whitespace_tags" {
  function_name = "moj-whitespace-test"
  role          = "arn:aws:iam::123456789012:role/lambda-role"
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  tags = {
    business-unit    = "   "  # Whitespace only
    application      = "  "   # Whitespace only
    owner            = "COAT Team: coat@digital.justice.gov.uk"
    is-production    = "false"
    service-area     = " "    # Single space
    environment-name = "test"
  }
}

# Invalid: No tags at all
resource "aws_dynamodb_table" "no_tags" {
  name         = "moj-no-tags-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
