# Edge cases for testing plan-based checkov scanning
# These test if checkov can detect issues in RESOLVED variable values

# Test 1: Valid tags via variables (should PASS)
# Uses default provider from valid.tf which has all required tags
resource "aws_s3_bucket" "plan_test_valid" {
  bucket = "moj-plan-test-valid-bucket"
  # Tags inherited from provider default_tags with valid variable values
}

# Test 2: Resource using provider with empty variable values (should FAIL with plan scanning)
resource "aws_dynamodb_table" "plan_test_empty_vars" {
  provider     = aws.invalid_values
  name         = "moj-plan-test-empty-vars"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  # Tags come from provider with empty/whitespace variable values
  # Plan scanning should resolve these and detect the empty values
}

# Test 3: Resource using provider with missing tags (should FAIL)
resource "aws_sqs_queue" "plan_test_missing_tags" {
  provider = aws.incomplete_tags
  name     = "moj-plan-test-missing-tags"
  # Provider only has partial tags - should fail for missing required tags
}

# Test 4: Resource with direct empty tag value (should FAIL)
resource "aws_sns_topic" "plan_test_direct_empty" {
  name = "moj-plan-test-direct-empty"

  tags = {
    custom-override = ""  # Direct empty value - should be caught
  }
}
