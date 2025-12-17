# Invalid test values to demonstrate tag enforcement failures
# These values simulate common mistakes teams might make

# Scenario: Empty and whitespace values
business_unit = "Platforms"
namespace     = ""           # Empty - should fail
application   = "  "         # Whitespace only - should fail
environment   = "development"
owner         = "   "        # Whitespace only - should fail
service_area  = ""           # Empty - should fail
is_production = "false"
