resource "aws_sns_topic" "zero_tags" {
  provider = aws.no_default_tags
  name     = "demo-zero-tags-topic"
}
