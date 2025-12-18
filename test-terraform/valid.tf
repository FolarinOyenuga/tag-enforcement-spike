# Valid configuration using provider-level default_tags (MoJ pattern)

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

  default_tags {
    tags = {
      business-unit = var.business_unit
      application   = var.application
      is-production = var.is_production
      owner         = var.owner
      namespace     = var.namespace
      service-area  = var.service_area
      environment   = var.environment
    }
  }
}

# Valid: Tags inherited from provider default_tags
resource "aws_s3_bucket" "valid_bucket" {
  bucket = "moj-valid-test-bucket"
}

resource "aws_instance" "valid_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
