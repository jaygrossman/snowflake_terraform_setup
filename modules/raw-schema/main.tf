# The raw-schema module creates a schema in the RAW database, intended as an entrypoint for data into Snowflake.
# The LOAD_ROLE owns the schema.
# this module creates:
#  - a schema
#  - a file format for loading data into the schema
#  - permissions on the schema and file format

terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.53.0"
    }
  }
}


resource "snowflake_schema" "this" {
  database = "RAW"
  name     = var.schema_name

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}


resource "snowflake_schema_grant" "ownership_grant" {
  database_name = "RAW"
  schema_name   = var.schema_name

  privilege              = "OWNERSHIP"
  roles                  = ["LOAD_ROLE"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.this]
}

resource "snowflake_schema_grant" "create_file_format_grant" {
  database_name = "RAW"
  schema_name   = var.schema_name

  privilege              = "CREATE FILE FORMAT"
  roles                  = ["ACCOUNTADMIN"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.this]
}

resource "snowflake_schema_grant" "create_stage_grant" {
  database_name = "RAW"
  schema_name   = var.schema_name

  privilege              = "CREATE STAGE"
  roles                  = ["ACCOUNTADMIN"]
  with_grant_option      = false
  enable_multiple_grants = true
  depends_on             = [snowflake_schema.this]
}


resource "snowflake_file_format" "this" {
  name          = var.file_format_name
  database      = "RAW"
  schema        = var.schema_name
  format_type   = var.file_format_type
  compression   = var.file_format_compression
  binary_format = var.file_format_binary_format
  depends_on    = [snowflake_schema_grant.create_file_format_grant]
}


resource "snowflake_file_format_grant" "load_role_file_format_usage_grant" {
  database_name    = "RAW"
  schema_name      = var.schema_name
  file_format_name = var.file_format_name

  privilege         = "USAGE"
  roles             = ["LOAD_ROLE"]
  on_future         = false
  with_grant_option = false

  depends_on = [snowflake_file_format.this]
}

