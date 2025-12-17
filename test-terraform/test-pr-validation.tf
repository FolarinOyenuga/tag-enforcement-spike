# Test file to validate tfsec PR pipeline
# This resource is missing required tags and should trigger tfsec failures

resource "aws_sqs_queue" "missing_all_tags" {
  name = "test-queue-no-tags"
  # No tags - should fail all 6 MOJ tag checks
}
