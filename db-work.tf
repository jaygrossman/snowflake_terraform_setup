# The WORK database is where analysts/business sponsors can explore data exposed to them
# from the ANALYTICS database, as well as other assorted non-company datasets we may provide


resource "snowflake_database" "work" {
  name                        = "WORK"
  data_retention_time_in_days = 1
}

resource "snowflake_database_grant" "grant_work_db_usage" {
  database_name          = "WORK"
  privilege              = "USAGE"
  roles                  = ["TRANSFORM_ROLE", "REPORT_ROLE", "ANALYST_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
  depends_on             = [snowflake_database.work]
}
