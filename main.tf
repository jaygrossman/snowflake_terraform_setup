
terraform {
  required_version = "~> 1.0"

  # we would want to centralize storing state externally (on s3)
  # before rolling this out to production
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.53.0"
    }
  }
}

