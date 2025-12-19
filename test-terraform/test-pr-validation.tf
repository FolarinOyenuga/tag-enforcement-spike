# Test file to validate tfsec PR pipeline
# This resource uses provider without default_tags to trigger failures

resource "aws_sqs_queue" "missing_all_tags" {
  provider = aws.no_default_tags
  name     = "test-queue-no-tags"
  # No tags inherited from provider - should fail all MOJ tag checks
}

resource "aws_lambda_function" "no_tags" {
  provider      = aws.no_default_tags
  function_name = "moj-lambda-no-tags"
  role          = "arn:aws:iam::123456789012:role/lambda-role"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  filename      = "lambda.zip"  # Required for terraform plan
  # No tags - should fail
}
