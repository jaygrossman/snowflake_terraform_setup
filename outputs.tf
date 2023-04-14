output "integration_snowflake_user_arn" {
  value = snowflake_storage_integration.stage_lambda_s3_integration.storage_aws_iam_user_arn
}
output "integration_snowflake_external_id" {
  value = snowflake_storage_integration.stage_lambda_s3_integration.storage_aws_external_id
}

