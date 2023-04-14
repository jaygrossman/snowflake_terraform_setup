variable "schema_name" {
  type        = string
  description = "The name of the schema that will be going in the RAW database."
}

variable "file_format_name" {
  type        = string
  description = "The name of the file format used to load data into RAW database schema."
  default     = "JSON_MONGO"
}

variable "file_format_type" {
  type        = string
  description = "Any Snowflake-approved type, e.g. JSON, CSV, ..."
  default     = "JSON"
}

variable "file_format_compression" {
  type    = string
  default = "AUTO"
}

variable "file_format_binary_format" {
  type    = string
  default = "UTF-8"
}
