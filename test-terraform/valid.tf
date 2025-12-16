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

# Valid: All required MoJ tags present
resource "aws_s3_bucket" "valid_bucket" {
  bucket = "moj-valid-test-bucket"

  tags = {
    business-unit    = "Platforms"
    application      = "Tag Enforcement Spike"
    owner            = "COAT Team: coat@digital.justice.gov.uk"
    is-production    = "false"
    service-area     = "Cloud Optimisation"
    environment-name = "test"
  }
}

resource "aws_instance" "valid_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    business-unit    = "Platforms"
    application      = "Tag Enforcement Spike"
    owner            = "COAT Team: coat@digital.justice.gov.uk"
    is-production    = "false"
    service-area     = "Cloud Optimisation"
    environment-name = "test"
  }
}
