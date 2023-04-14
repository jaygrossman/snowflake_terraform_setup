# ANALYTICS.trans is a schema for intermediate dbt models.
# dbt gets data from the RAW database tables and transforms it
# in the the ANALYTICS.trans schema; the tables then feed the
# tables/views in the ANALYTICS.export and ANALYTICS.rpt schemas

resource "snowflake_schema" "analytics_trans_schema" {
  database = "ANALYTICS"
  name     = "TRANS"

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

resource "snowflake_schema_grant" "analytics_trans_owner_grant" {
  database_name = "ANALYTICS"
  schema_name   = "TRANS"

  privilege              = "OWNERSHIP"
  roles                  = ["TRANSFORM_ROLE"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.analytics_trans_schema]
}
