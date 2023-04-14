# snowflake_terraform_setup

This directory contains terraform configuration used to configure a snowflake instance with a generic set up disucssed at:
http://jaygrossman.com/post/2023/01/28/Snowflake-Set-up-with-Terraform.aspx

## What are we using terraform to configure within snowflake??
- databases
- warehouses
- roles
- schemas
- user accounts
- permission grants

## Chan Zuckerberg terraform provider
This is a terraform provider plugin for managing Snowflake accounts:
https://github.com/chanzuckerberg/terraform-provider-snowflake

Documentation available here:
https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs

## Running terraform

1. install terraform - https://www.terraform.io/downloads
2. clone this repo
3. go to snowflake directory
```sh
cd snowflake
```
4. run the following commands to set environment variables (replace Account, Region and the UserName and Password for ACCOUNTADMIN role):
```sh
export SNOWFLAKE_ACCOUNT=${ACCOUNT}
export SNOWFLAKE_REGION=${REGION}
export SNOWFLAKE_USER=${USERNAME}
export SNOWFLAKE_PASSWORD=${PASSWORD}
export SNOWFLAKE_ROLE=ACCOUNTADMIN
```
5. call terraform init to initialize the terraform configuration:
```sh
terraform init
```
6. call terraform to show a plan of configured changes:
```sh
terraform plan
```
7. call terraform to apply configured changes:
```sh
terraform apply
```
