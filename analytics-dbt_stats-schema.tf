# ANALYTICS.db_stats is a schema for tables/views with e.g. metadata 
# about our dbt models like total runtime, last runtime, number of rows
# added incrementally, etc

resource "snowflake_schema" "analytics_db_stats_schema" {
  database = "ANALYTICS"
  name     = "DB_STATS"
  comment  = "ANALYTICS.db_stats is a schema for tables/views with e.g. metadata about our dbt models like total runtime, last runtime, etc"

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

resource "snowflake_schema_grant" "analytics_db_stats_owner_grant" {
  database_name = "ANALYTICS"
  schema_name   = snowflake_schema.analytics_db_stats_schema.name

  privilege              = "OWNERSHIP"
  roles                  = ["TRANSFORM_ROLE"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.analytics_db_stats_schema]
}

resource "snowflake_schema_grant" "analytics_db_stats_usage_grant" {
  database_name = "ANALYTICS"
  schema_name   = snowflake_schema.analytics_db_stats_schema.name

  privilege              = "USAGE"
  roles                  = ["ANALYST_ROLE"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.analytics_db_stats_schema]
}
