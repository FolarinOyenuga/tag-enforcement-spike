resource "aws_sqs_queue" "feature_queue" {
  provider = aws.no_default_tags
  name     = "feature-valid-queue"

  tags = {
    business-unit = ""
    namespace     = "cloud-platform"
    application   = "Feature Valid Tags Test"
    environment   = "development"
    owner         = "COAT: cloud-optimisation@digital.justice.gov.uk"
    service-area  = "Cloud Optimisation"
    is-production = "false"
  }
}
