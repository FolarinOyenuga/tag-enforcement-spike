from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckCategories, CheckResult
from typing import Any, List


class AWSResourceRequiredTags(BaseResourceCheck):
    TAGGABLE_RESOURCES = [
        "aws_s3_bucket",
        "aws_instance",
        "aws_db_instance",
        "aws_rds_cluster",
        "aws_lambda_function",
        "aws_dynamodb_table",
        "aws_ecs_cluster",
        "aws_ecs_service",
        "aws_eks_cluster",
        "aws_vpc",
        "aws_subnet",
        "aws_security_group",
        "aws_iam_role",
        "aws_kms_key",
        "aws_cloudwatch_log_group",
        "aws_ecr_repository",
        "aws_elasticache_cluster",
        "aws_elasticsearch_domain",
        "aws_opensearch_domain",
        "aws_route53_zone",
        "aws_acm_certificate",
        "aws_elb",
        "aws_lb",
        "aws_alb",
        "aws_api_gateway_rest_api",
        "aws_apigatewayv2_api",
        "aws_sqs_queue",
        "aws_sns_topic",
    ]

    def __init__(self):
        name = "Ensure AWS resources have all required MoJ tags with non-empty values"
        id = "CKV_MOJ_001"
        supported_resources = self.TAGGABLE_RESOURCES
        categories = [CheckCategories.CONVENTION]
        super().__init__(
            name=name,
            id=id,
            categories=categories,
            supported_resources=supported_resources
        )

        self.required_tags = [
            "business-unit",
            "namespace",
            "application",
            "environment",
            "owner",
            "service-area",
            "is-production"
        ]

    def scan_resource_conf(self, conf: dict[str, Any]) -> CheckResult:
        tags = conf.get("tags_all") or conf.get("tags") or {}

        if isinstance(tags, list) and len(tags) > 0:
            tags = tags[0]
        
        if not isinstance(tags, dict):
            tags = {}

        missing_tags = []
        empty_tags = []

        for required_tag in self.required_tags:
            if required_tag not in tags:
                missing_tags.append(required_tag)
            else:
                value = tags.get(required_tag)
                if isinstance(value, list) and len(value) > 0:
                    value = value[0]
                if value is None or (isinstance(value, str) and value.strip() == ""):
                    empty_tags.append(required_tag)

        if missing_tags or empty_tags:
            self.details.append(f"Missing: {missing_tags}, Empty: {empty_tags}")
            return CheckResult.FAILED

        return CheckResult.PASSED


check = AWSResourceRequiredTags()
