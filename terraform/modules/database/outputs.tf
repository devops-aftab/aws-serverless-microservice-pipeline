output "table_name" {
  description = "Name of the provisioned DynamoDB table"
  value       = aws_dynamodb_table.items_table.name
}

output "table_arn" {
  description = "ARN of the provisioned DynamoDB table"
  value       = aws_dynamodb_table.items_table.arn
}