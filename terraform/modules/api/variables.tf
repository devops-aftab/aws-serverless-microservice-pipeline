variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name passed from database module"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "DynamoDB table ARN passed from database module for IAM scoping"
  type        = string
}