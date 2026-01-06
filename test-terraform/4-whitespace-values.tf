resource "aws_dynamodb_table" "whitespace_values" {
  provider       = aws.no_default_tags
  name           = "demo-whitespace-values"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    business-unit = "OPG"
    namespace     = "opg-namespace"
    application   = "   "
    environment   = "staging"
    owner         = "    "
    service-area  = "Digital Services"
    is-production = "false"
  }
}
