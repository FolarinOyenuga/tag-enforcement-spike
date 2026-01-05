# MoJ Tag Enforcement Policy
# Cloud-agnostic: validates tags on AWS, Azure, and GCP resources via Terraform plan JSON

package main

import future.keywords.in
import future.keywords.contains
import future.keywords.if

required_tags := [
    "business-unit",
    "namespace",
    "application",
    "environment",
    "owner",
    "service-area",
    "is-production"
]

deny contains msg if {
    resource := input.resource_changes[_]
    resource.change.actions[_] != "delete"
    is_taggable_resource(resource)
    
    tags := get_tags(resource)
    count(tags) == 0
    
    msg := sprintf("Resource '%s' (%s) has no tags - all required MoJ tags must be present: %v", [
        resource.address,
        resource.type,
        required_tags
    ])
}

deny contains msg if {
    resource := input.resource_changes[_]
    resource.change.actions[_] != "delete"
    
    tags := get_tags(resource)
    count(tags) > 0
    
    missing := missing_tags(tags)
    count(missing) > 0
    
    msg := sprintf("Resource '%s' (%s) is missing required tags: %v", [
        resource.address,
        resource.type,
        missing
    ])
}

deny contains msg if {
    resource := input.resource_changes[_]
    resource.change.actions[_] != "delete"
    
    tags := get_tags(resource)
    count(tags) > 0
    
    empty := empty_tags(tags)
    count(empty) > 0
    
    msg := sprintf("Resource '%s' (%s) has empty/whitespace tag values: %v", [
        resource.address,
        resource.type,
        empty
    ])
}

is_taggable_resource(resource) if {
    startswith(resource.type, "aws_")
}

is_taggable_resource(resource) if {
    startswith(resource.type, "azurerm_")
}

is_taggable_resource(resource) if {
    startswith(resource.type, "google_")
}

get_tags(resource) := tags if {
    tags := resource.change.after.tags_all
    not is_null(tags)
    is_object(tags)
} else := tags if {
    tags := resource.change.after.tags
    not is_null(tags)
    is_object(tags)
} else := tags if {
    tags := resource.change.after.labels
    not is_null(tags)
    is_object(tags)
} else := {}

missing_tags(tags) := missing if {
    missing := [tag | 
        tag := required_tags[_]
        not tag in object.keys(tags)
    ]
}

empty_tags(tags) := empty if {
    empty := [tag |
        tag := required_tags[_]
        tag in object.keys(tags)
        is_empty_value(tags[tag])
    ]
}

is_empty_value(value) if {
    value == null
}

is_empty_value(value) if {
    value == ""
}

is_empty_value(value) if {
    trim_space(value) == ""
}
