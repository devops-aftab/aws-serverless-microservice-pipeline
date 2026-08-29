output "api_endpoint" {
  description = "HTTP API Gateway endpoint URL"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api_handler.function_name
}