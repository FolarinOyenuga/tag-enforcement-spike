from checkov.terraform.checks.provider.base_check import BaseProviderCheck
from checkov.common.models.enums import CheckCategories, CheckResult


class AWSProviderDefaultTags(BaseProviderCheck):
    """
    Check that AWS provider has all required MoJ tags in default_tags.
    This check validates both tag presence AND that values are non-empty.
    """

    def __init__(self):
        name = "Ensure AWS provider has all required MoJ tags in default_tags with non-empty values"
        id = "CKV_MOJ_001"
        supported_provider = ["aws"]
        categories = [CheckCategories.CONVENTION]
        super().__init__(name=name, id=id, categories=categories, supported_provider=supported_provider)

        self.required_tags = [
            "business-unit",
            "namespace",
            "application",
            "environment",
            "owner",
            "service-area",
            "is-production"
        ]

    def scan_provider_conf(self, conf):
        """
        Validates that the AWS provider has default_tags with all required MoJ tags.
        Also validates that tag values are not empty or whitespace-only.
        """
        # Check if default_tags exists
        if "default_tags" not in conf:
            return CheckResult.FAILED

        default_tags = conf.get("default_tags", [])
        if not default_tags:
            return CheckResult.FAILED

        # default_tags is a list of dicts
        tags_block = default_tags[0] if isinstance(default_tags, list) else default_tags
        tags = tags_block.get("tags", [])

        if not tags:
            return CheckResult.FAILED

        # tags is a list with one dict
        if isinstance(tags, list) and len(tags) > 0:
            tags = tags[0]

        missing_tags = []
        empty_tags = []

        for required_tag in self.required_tags:
            if required_tag not in tags:
                missing_tags.append(required_tag)
            else:
                # Check if value is empty or whitespace-only
                value = tags.get(required_tag)
                if isinstance(value, list) and len(value) > 0:
                    value = value[0]
                if value is None or (isinstance(value, str) and value.strip() == ""):
                    empty_tags.append(required_tag)

        if missing_tags or empty_tags:
            return CheckResult.FAILED

        return CheckResult.PASSED


check = AWSProviderDefaultTags()
