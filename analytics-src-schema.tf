# ANALYTICS.src is a schema for holding dbt models of data that has been
# lightly transformed from the original source data.
# Example:
# - raw postgres data from Fivetran that excludes _fivetran_deleted records
# - nested raw Mongo data that gets flattened
# Also holds the functions we define, e.g. ANALYTICS.src.function_eu_30_360_year_frac()

resource "snowflake_schema" "analytics_src_schema" {
  database = "ANALYTICS"
  name     = "SRC"

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

resource "snowflake_schema_grant" "analytics_src__owner_grant" {
  database_name = "ANALYTICS"
  schema_name   = "SRC"

  privilege              = "OWNERSHIP"
  roles                  = ["TRANSFORM_ROLE"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.analytics_src_schema]
}


resource "snowflake_schema_grant" "analytics_src_owner_grant2" {
  database_name = "ANALYTICS"
  schema_name   = "SRC"

  privilege              = "CREATE FUNCTION"
  roles                  = ["ACCOUNTADMIN"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.analytics_src_schema]
}


###############
## FUNCTIONS ##
###############
resource "snowflake_function" "function_format_uuid_from_binary_conversion" {
  name        = "format_uuid_from_binary_conversion"
  database    = "ANALYTICS"
  schema      = "SRC"
  return_type = "VARCHAR"
  language    = "javascript"
  arguments {
    name = "S"
    type = "VARCHAR"
  }
  statement = "return S.substr(0, 8) + '-' + S.substr(8, 4) + '-' + S.substr(12, 4) + '-' + S.substr(16, 4) + '-' + S.substr(20, 12);"
}


resource "snowflake_function" "function_string_cleanup" {
  name        = "string_cleanup"
  database    = "ANALYTICS"
  schema      = "SRC"
  return_type = "VARCHAR"
  arguments {
    name = "I"
    type = "VARCHAR"
  }
  statement = "select UPPER(TRIM(REGEXP_REPLACE(REPLACE(REPLACE(i, CHAR(13), ''), CHAR(10), ''), ' \\+', ' ')))"
}

resource "snowflake_function" "function_is_last_day_of_february" {
  name        = "IS_LAST_DAY_OF_FEB"
  database    = "ANALYTICS"
  schema      = "SRC"
  comment     = "Takes a date, TRUE if date is the last day of February, FALSE otherwise.  Used in the 30/360 year fraction calculation."
  return_type = "BOOLEAN"
  arguments {
    name = "THE_DATE"
    type = "DATE"
  }
  statement = file("./snowflake-functions/function_is_last_day_of_february.sql")
}

resource "snowflake_function" "function_us_30_360_year_frac" {
  name        = "US_30_360_YEAR_FRAC"
  database    = "ANALYTICS"
  schema      = "SRC"
  comment     = "Calculate time between first and second date as fraction of a year, normalized according to the US (NASD) 30/360 convention.  See https://sqlsunday.com/2014/08/17/30-360-day-count-convention/."
  return_type = "NUMBER(16,6)"

  arguments {
    name = "FIRST_DATE"
    type = "DATE"
  }
  arguments {
    name = "SECOND_DATE"
    type = "DATE"
  }

  statement = file("./snowflake-functions/function_us_30_360_year_frac.sql")
}

resource "snowflake_function" "function_eu_30_360_year_frac" {
  name        = "EU_30_360_YEAR_FRAC"
  database    = "ANALYTICS"
  schema      = "SRC"
  comment     = "Calculate time between first and second date as fraction of a year, normalized according to the US (NASD) 30/360 convention.  See https://sqlsunday.com/2014/08/17/30-360-day-count-convention/."
  return_type = "NUMBER(16,6)"

  arguments {
    name = "FIRST_DATE"
    type = "DATE"
  }
  arguments {
    name = "SECOND_DATE"
    type = "DATE"
  }

  statement = file("./snowflake-functions/function_eu_30_360_year_frac.sql")
}

#####################
## FUNCTION GRANTS ##
#####################
resource "snowflake_function_grant" "function_format_uuid_from_binary_conversion_grant" {
  function_name = "format_uuid_from_binary_conversion"
  database_name = "ANALYTICS"
  schema_name   = "SRC"
  arguments {
    name = "S"
    type = "VARCHAR"
  }
  roles             = ["TRANSFORM_ROLE", "DATA_ENGINEER_ROLE"]
  privilege         = "USAGE"
  return_type       = "VARCHAR"
  with_grant_option = false
  depends_on        = [snowflake_function.function_format_uuid_from_binary_conversion]
  lifecycle {
    create_before_destroy = true
    #ignore_changes = [snowflake_function_grant.function_format_uuid_from_binary_conversion_grant]
  }
}

resource "snowflake_function_grant" "function_string_cleanup_grant" {
  function_name = "string_cleanup"
  database_name = "ANALYTICS"
  schema_name   = "SRC"
  arguments {
    name = "S"
    type = "VARCHAR"
  }
  roles             = ["TRANSFORM_ROLE", "DATA_ENGINEER_ROLE"]
  privilege         = "USAGE"
  return_type       = "VARCHAR"
  with_grant_option = false
  depends_on        = [snowflake_function.function_string_cleanup]
  lifecycle {
    create_before_destroy = true
    #ignore_changes = [snowflake_function_grant.function_format_uuid_from_binary_conversion_grant]
  }
}

resource "snowflake_function_grant" "function_is_last_day_of_february_grant" {
  function_name = snowflake_function.function_is_last_day_of_february.name
  database_name = snowflake_function.function_is_last_day_of_february.database
  schema_name   = snowflake_function.function_is_last_day_of_february.schema
  arguments {
    name = "THE_DATE"
    type = "DATE"
  }
  roles             = ["TRANSFORM_ROLE", "DATA_ENGINEER_ROLE"]
  privilege         = "USAGE"
  return_type       = snowflake_function.function_is_last_day_of_february.return_type
  with_grant_option = false
  depends_on        = [snowflake_function.function_is_last_day_of_february]
  lifecycle {
    create_before_destroy = true
  }
}

resource "snowflake_function_grant" "function_us_30_360_year_frac_grant" {
  function_name = snowflake_function.function_us_30_360_year_frac.name
  database_name = snowflake_function.function_us_30_360_year_frac.database
  schema_name   = snowflake_function.function_us_30_360_year_frac.schema
  arguments {
    name = "FIRST_DATE"
    type = "DATE"
  }
  arguments {
    name = "SECOND_DATE"
    type = "DATE"
  }
  roles             = ["TRANSFORM_ROLE", "DATA_ENGINEER_ROLE"]
  privilege         = "USAGE"
  return_type       = snowflake_function.function_us_30_360_year_frac.return_type
  with_grant_option = false
  depends_on        = [snowflake_function.function_us_30_360_year_frac]
  lifecycle {
    create_before_destroy = true
  }
}

resource "snowflake_function_grant" "function_eu_30_360_year_frac_grant" {
  function_name = snowflake_function.function_eu_30_360_year_frac.name
  database_name = snowflake_function.function_eu_30_360_year_frac.database
  schema_name   = snowflake_function.function_eu_30_360_year_frac.schema
  arguments {
    name = "FIRST_DATE"
    type = "DATE"
  }
  arguments {
    name = "SECOND_DATE"
    type = "DATE"
  }
  roles             = ["TRANSFORM_ROLE", "DATA_ENGINEER_ROLE"]
  privilege         = "USAGE"
  return_type       = snowflake_function.function_eu_30_360_year_frac.return_type
  with_grant_option = false
  depends_on        = [snowflake_function.function_eu_30_360_year_frac]
  lifecycle {
    create_before_destroy = true
  }
}
