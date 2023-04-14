################
## VARIABLES
################
variable "aws_key_id" {
  type        = string
  description = "AWS Key for Stages"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key for Stages"
}

locals {

  transform_role_users = [
    snowflake_user.DBT_USER,
  ]

  transform_role_user_names = [for u in local.transform_role_users : u.name]


  report_role_users = [
    snowflake_user.REPORT_USER,
  ]

  report_role_user_names = [for u in local.report_role_users : u.name]


  analyst_role_users = [
    snowflake_user.ANALYST_1,
  ]

  analyst_role_user_names = [for u in local.analyst_role_users : u.name]

}
