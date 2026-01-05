# MoJ Tag Enforcement Policy for Terraform Plan
# Validates that cloud resources have all required tags with non-empty values
# Cloud-agnostic: works with any resource that has tags/tags_all in the plan

package main

import future.keywords.in
import future.keywords.contains
import future.keywords.if

# Required MoJ tags
required_tags := [
    "business-unit",
    "namespace",
    "application",
    "environment",
    "owner",
    "service-area",
    "is-production"
]

# Deny if resource has NO tags at all
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

# Deny if resource is missing any required tags
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

# Deny if resource has empty tag values
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

# Check if resource is a taggable cloud resource
is_taggable_resource(resource) if {
    startswith(resource.type, "aws_")
}

is_taggable_resource(resource) if {
    startswith(resource.type, "azurerm_")
}

is_taggable_resource(resource) if {
    startswith(resource.type, "google_")
}

# Get tags from resource (checks tags_all first, then tags, then labels for GCP)
get_tags(resource) := tags if {
    tags := resource.change.after.tags_all
} else := tags if {
    tags := resource.change.after.tags
} else := tags if {
    tags := resource.change.after.labels
} else := {}

# Find missing required tags
missing_tags(tags) := missing if {
    missing := [tag | 
        tag := required_tags[_]
        not tag in object.keys(tags)
    ]
}

# Find tags with empty or whitespace-only values
empty_tags(tags) := empty if {
    empty := [tag |
        tag := required_tags[_]
        tag in object.keys(tags)
        is_empty_value(tags[tag])
    ]
}

# Check if value is empty or whitespace-only
is_empty_value(value) if {
    value == null
}

is_empty_value(value) if {
    value == ""
}

is_empty_value(value) if {
    trim_space(value) == ""
}
