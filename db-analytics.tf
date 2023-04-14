# The ANALYTICS database is for transformed or generated models/data sets,
# taht are well documented to support reporting and analysis needs.
# Users can directly query this data, but can not write/update.
# The TRANSFORM_ROLE owns schemas in this database.

resource "snowflake_database" "analytics" {
  name                        = "ANALYTICS"
  data_retention_time_in_days = 1
}


################
## DATABASE GRANTS
################

resource "snowflake_database_grant" "grant_analytics_db_usage" {
  database_name          = "ANALYTICS"
  privilege              = "USAGE"
  roles                  = ["TRANSFORM_ROLE", "REPORT_ROLE", "ANALYST_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_database_grant" "grant_analytics_db_ref_usage" {
  database_name          = "ANALYTICS"
  privilege              = "REFERENCE_USAGE"
  roles                  = ["TRANSFORM_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_database_grant" "grant_analytics_db_ref_monitor" {
  database_name          = "ANALYTICS"
  privilege              = "MONITOR"
  roles                  = ["TRANSFORM_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_database_grant" "grant_analytics_db_ref_create_schema" {
  database_name          = "ANALYTICS"
  privilege              = "CREATE SCHEMA"
  roles                  = ["TRANSFORM_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_view_grant" "grant" {
  database_name     = "ANALYTICS"
  privilege         = "SELECT"
  roles             = [ "ANALYST_ROLE"]
  on_future         = true
  with_grant_option = true
}
