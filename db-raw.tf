# The RAW database is an entrypoint into our Snowflake datawarehouse.
# Schemas in this database hold tables with raw data ingested from various source systems in their native formats.
# The LOAD_ROLE owns schemas in this database.

resource "snowflake_database" "raw" {
  name                        = "RAW"
  data_retention_time_in_days = 1
}

# db grants
resource "snowflake_database_grant" "grant_raw_db_usage" {
  database_name          = "RAW"
  privilege              = "USAGE"
  roles                  = ["TRANSFORM_ROLE", "LOAD_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_database_grant" "grant_raw_db_ref_usage" {
  database_name          = "RAW"
  privilege              = "REFERENCE_USAGE"
  roles                  = ["TRANSFORM_ROLE", "LOAD_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_database_grant" "grant_raw_db_monitor" {
  database_name          = "RAW"
  privilege              = "MONITOR"
  roles                  = ["TRANSFORM_ROLE", "LOAD_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_database_grant" "grant_raw_db_create_schema" {
  database_name          = "RAW"
  privilege              = "CREATE SCHEMA"
  roles                  = ["LOAD_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}


# schemas

# here we can set up schemas for each of our raw providers.
# our convention is to signify the platform and the source.
# examples:

#module "raw_mongo_product_schema" {
#  source      = "./modules/raw-schema"
#  schema_name = "MONGO_ECOMMERCE"
#}

#module "raw_postgres_schema" {
#  source                    = "./modules/raw-schema"
#  schema_name               = "POSTGRES"
#  file_format_name          = "PARQUET"
#  file_format_type          = "parquet"
#  file_format_compression   = "AUTO"
#  file_format_binary_format = null
#}
