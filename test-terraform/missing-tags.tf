resource "aws_sqs_queue" "missing_tags" {
  provider = aws.no_default_tags
  name     = "demo-missing-tags-queue"

  tags = {
    business-unit = "HMPPS"
    application   = "Missing Tags Demo"
  }
}
