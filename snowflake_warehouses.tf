##################
## WAREHOUSES
################


resource "snowflake_warehouse" "LOAD_WH" {
  name              = "LOAD_WH"
  warehouse_size    = "X-Small"
  auto_resume       = true
  auto_suspend      = 60
  max_cluster_count = 1
  min_cluster_count = 1
  scaling_policy    = "STANDARD"
}
resource "snowflake_warehouse" "REPORT_WH" {
  name              = "REPORT_WH"
  warehouse_size    = "X-Small"
  auto_resume       = true
  auto_suspend      = 60
  max_cluster_count = 1
  min_cluster_count = 1
  scaling_policy    = "STANDARD"
}
resource "snowflake_warehouse" "ANALYST_WH" {
  name              = "ANALYST_WH"
  warehouse_size    = "X-Small"
  auto_resume       = true
  auto_suspend      = 60
  max_cluster_count = 1
  min_cluster_count = 1
  scaling_policy    = "STANDARD"
}
resource "snowflake_warehouse" "TRANSFORM_WH" {
  name              = "TRANSFORM_WH"
  warehouse_size    = "X-Small"
  auto_resume       = true
  auto_suspend      = 60
  max_cluster_count = 1
  min_cluster_count = 1
  scaling_policy    = "STANDARD"
}

# ################
# ## WAREHOUSE GRANTS
# ################

resource "snowflake_warehouse_grant" "load_wh_grant" {
  warehouse_name = "LOAD_WH"
  privilege      = "USAGE"

  roles                  = ["LOAD_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_warehouse_grant" "load_wh_grant_op" {
  warehouse_name = "LOAD_WH"
  privilege      = "OPERATE"

  roles                  = ["LOAD_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_warehouse_grant" "transform_wh_grant" {
  warehouse_name = "TRANSFORM_WH"
  privilege      = "USAGE"

  roles                  = ["TRANSFORM_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_warehouse_grant" "transform_wh_grant_op" {
  warehouse_name = "TRANSFORM_WH"
  privilege      = "OPERATE"

  roles                  = ["TRANSFORM_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_warehouse_grant" "report_wh_grant" {
  warehouse_name = "REPORT_WH"
  privilege      = "USAGE"

  roles                  = ["REPORT_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_warehouse_grant" "report_wh_grant_op" {
  warehouse_name = "REPORT_WH"
  privilege      = "OPERATE"

  roles                  = ["REPORT_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}


resource "snowflake_warehouse_grant" "analyst_wh_grant" {
  warehouse_name = "ANALYST_WH"
  privilege      = "USAGE"

  roles                  = ["ANALYST_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_warehouse_grant" "analyst_wh_grant_op" {
  warehouse_name = "ANALYST_WH"
  privilege      = "OPERATE"

  roles                  = ["ANALYST_ROLE"]
  enable_multiple_grants = true
  with_grant_option      = false
}
