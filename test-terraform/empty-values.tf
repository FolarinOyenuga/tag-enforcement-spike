resource "aws_sns_topic" "empty_values" {
  provider = aws.no_default_tags
  name     = "demo-empty-values-topic"

  tags = {
    business-unit = "LAA"
    namespace     = ""
    application   = "Empty Values Demo"
    environment   = "test"
    owner         = "LAA Team: laa@digital.justice.gov.uk"
    service-area  = ""
    is-production = "false"
  }
}
