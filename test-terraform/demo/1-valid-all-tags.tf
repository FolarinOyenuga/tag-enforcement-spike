resource "aws_s3_bucket" "valid_bucket" {
  provider = aws.no_default_tags
  bucket   = "demo-valid-bucket"

  tags = {
    business-unit    = "Platforms"
    namespace        = "cloud-platform"
    application      = "Tag Enforcement Demo"
    environment      = "development"
    owner            = "COAT: cloud-optimisation@digital.justice.gov.uk"
    service-area     = "Cloud Optimisation"
    is-production    = "false"
  }
}
