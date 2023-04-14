# ANALYTICS.rpt is a schema for holding dbt models that drive
# our BI reporting.
# Example:
# - PowerBI reports

resource "snowflake_schema" "analytics_rpt_schema" {
  database = "ANALYTICS"
  name     = "RPT"

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

resource "snowflake_schema_grant" "analytics_rpt_usage_grant" {
  database_name = "ANALYTICS"
  schema_name   = "RPT"

  privilege              = "USAGE"
  roles                  = ["REPORT_ROLE", "ANALYST_ROLE"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.analytics_rpt_schema]
}

resource "snowflake_view_grant" "rpt_view_grant_future" {
  database_name          = "ANALYTICS"
  schema_name            = "RPT"
  privilege              = "SELECT"
  roles                  = ["REPORT_ROLE", "ANALYST_ROLE"]
  on_future              = true
  enable_multiple_grants = true
  with_grant_option      = false
}


resource "snowflake_schema_grant" "analytics_rpt_owner_grant" {
  database_name = "ANALYTICS"
  schema_name   = "RPT"

  privilege              = "OWNERSHIP"
  roles                  = ["TRANSFORM_ROLE"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.analytics_rpt_schema]
}


resource "snowflake_table_grant" "rpt_table_grant_future" {
  database_name          = "ANALYTICS"
  enable_multiple_grants = true
  on_future              = true
  privilege              = "SELECT"
  roles = [
    "ANALYST_ROLE",
    "DATA_ENGINEER_ROLE",
    "REPORT_ROLE",
  ]
  schema_name       = "RPT"
  with_grant_option = false
}
