# Test file to validate tfsec PR pipeline
# This resource uses provider without default_tags to trigger failures

resource "aws_sqs_queue" "missing_all_tags" {
  provider = aws.no_default_tags
  name     = "test-queue-no-tags"

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

resource "aws_lambda_function" "no_tags" {
  provider      = aws.no_default_tags
  function_name = "moj-lambda-no-tags"
  role          = "arn:aws:iam::123456789012:role/lambda-role"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  filename      = "lambda.zip"
  
  tags = {
    business-unit    = var.business_unit
    namespace        = var.namespace
    application      = var.application
    environment      = var.environment
    owner            = var.owner
    service-area     = var.service_area
    is-production    = var.is_production
  }
}

# Test resource for OPA validation - missing required tags
resource "aws_sns_topic" "opa_test_missing_tags" {
  provider = aws.no_default_tags
  name     = "opa-test-topic"
  
  tags = {
    business-unit = var.business_unit
    application   = var.application
  }
}

# Edge case: empty tag values
resource "aws_sqs_queue" "opa_test_empty_tags" {
  provider = aws.no_default_tags
  name     = "opa-test-empty-tags"
  
  tags = {
    business-unit = var.business_unit
    namespace     = var.namespace_invalid      # empty ""
    application   = var.application
    environment   = var.environment
    owner         = var.owner
    service-area  = var.service_area_invalid   # empty ""
    is-production = var.is_production
  }
}

# Edge case: whitespace-only tag values
resource "aws_dynamodb_table" "opa_test_whitespace_tags" {
  provider       = aws.no_default_tags
  name           = "opa-test-whitespace-tags"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  
  attribute {
    name = "id"
    type = "S"
  }
  
  tags = {
    business-unit = var.business_unit
    namespace     = var.namespace
    application   = var.application_invalid    # whitespace "  "
    environment   = var.environment
    owner         = var.owner_invalid          # whitespace "   "
    service-area  = var.service_area
    is-production = var.is_production
  }
}

# Edge case: no tags at all
resource "aws_sns_topic" "opa_test_zero_tags" {
  provider = aws.no_default_tags
  name     = "opa-test-zero-tags"
}
