output "s3_bucket_name" {
  description = "S3 bucket name for frontend"
  value       = aws_s3_bucket.frontend.bucket
}

output "dynamodb_products_table" {
  description = "DynamoDB products table name"
  value       = aws_dynamodb_table.products.name
}

output "dynamodb_orders_table" {
  description = "DynamoDB orders table name"
  value       = aws_dynamodb_table.orders.name
}

output "api_gateway_url" {
  description = "API Gateway URL"
  value       = aws_apigatewayv2_api.alma_api.api_endpoint
}

output "lambda_list_products" {
  description = "Lambda function name for listing products"
  value       = aws_lambda_function.list_products.function_name
}

output "lambda_process_order" {
  description = "Lambda function name for processing orders"
  value       = aws_lambda_function.process_order.function_name
}
