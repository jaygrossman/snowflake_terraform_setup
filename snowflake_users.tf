# Below is where we define the users in our system.
# NOTE: We intentionally decided not to assign passwords here, as we do this in the GUI or CLI to force them to be reset on first login.
# When adding new users, you will need to assign their roles in variables.tf

################
## USERS
################

# End User set up the can read from ANALYTICS database
resource "snowflake_user" "ANALYST_1" {
  default_role      = "ANALYST_ROLE"
  default_warehouse = "ANALYST_WH"
  disabled          = false
  display_name      = "ANALYST_1"
  login_name        = "ANALYST_1"
  name              = "ANALYST_1"
}

# User that dbt runs under that can write to ANALYTICS database
resource "snowflake_user" "DBT_USER" {
  default_role      = "TRANSFORM_ROLE"
  default_warehouse = "TRANSFORM_WH"
  disabled          = false
  display_name      = "DBT_USER"
  login_name        = "DBT_USER"
  name              = "DBT_USER"
}

# User that fivetran runs under that can write to RAW database
resource "snowflake_user" "fivetran_user" {
  default_role      = "LOAD_ROLE"
  default_warehouse = "LOAD_WH"
  disabled          = false
  display_name      = "FIVETRAN_USER"
  login_name        = "FIVETRAN_USER"
  name              = "FIVETRAN_USER"
}

# User that metabase connects using that can read from ANALYTICS database
resource "snowflake_user" "METABASE_USER" {
  default_role      = "REPORT_ROLE"
  default_warehouse = "REPORT_WH"
  disabled          = false
  display_name      = "METABASE_USER"
  login_name        = "METABASE_USER"
  name              = "METABASE_USER"
}

# User that scripted reporting connects using that can read from ANALYTICS database
resource "snowflake_user" "REPORT_USER" {
  default_role      = "REPORT_ROLE"
  default_warehouse = "REPORT_WH"
  disabled          = false
  display_name      = "REPORT_USER"
  login_name        = "REPORT_USER"
  name              = "REPORT_USER"
}

################
## USERS ROLE GRANTS
################

resource "snowflake_role_grants" "transfrom_role_user_grants" {
  role_name = snowflake_role.transform_role.name
  users     = local.transform_role_user_names
}

resource "snowflake_role_grants" "report_role_user_grants" {
  role_name = snowflake_role.report_role.name
  users     = local.report_role_user_names
}

resource "snowflake_role_grants" "analyst_role_user_grants" {
  role_name = snowflake_role.analyst_role.name
  users     = local.analyst_role_user_names
}

