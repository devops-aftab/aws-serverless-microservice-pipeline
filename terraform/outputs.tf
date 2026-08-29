output "api_endpoint" {
  description = "Base HTTP API Gateway endpoint URL"
  value       = module.api.api_endpoint
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.database.table_name
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.api.lambda_function_name
}