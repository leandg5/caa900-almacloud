terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for frontend
resource "aws_s3_bucket" "frontend" {
  bucket = "caa900-almacloud-frontend"
  tags = {
    Name    = "caa900-almacloud-frontend"
    Project = "ALMA Cloud"
    Team    = "ALMA Cloud"
  }
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  index_document {
    suffix = "index.html"
  }
}

# DynamoDB - Products Table
resource "aws_dynamodb_table" "products" {
  name         = "Alma-products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name    = "Alma-products"
    Project = "ALMA Cloud"
    Team    = "ALMA Cloud"
  }
}

# DynamoDB - Orders Table
resource "aws_dynamodb_table" "orders" {
  name         = "Alma-orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name    = "Alma-orders"
    Project = "ALMA Cloud"
    Team    = "ALMA Cloud"
  }
}

# Lambda - List Products
resource "aws_lambda_function" "list_products" {
  filename         = "lambda_list_products.zip"
  function_name    = "alma-list-products"
  role             = "arn:aws:iam::012906612629:role/LabRole"
  handler          = "index.handler"
  runtime          = "nodejs24.x"

  tags = {
    Name    = "alma-list-products"
    Project = "ALMA Cloud"
    Team    = "ALMA Cloud"
  }
}

# Lambda - Process Order
resource "aws_lambda_function" "process_order" {
  filename         = "lambda_process_order.zip"
  function_name    = "alma-process-order"
  role             = "arn:aws:iam::012906612629:role/LabRole"
  handler          = "index.handler"
  runtime          = "nodejs24.x"

  tags = {
    Name    = "alma-process-order"
    Project = "ALMA Cloud"
    Team    = "ALMA Cloud"
  }
}

# API Gateway
resource "aws_apigatewayv2_api" "alma_api" {
  name          = "alma-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["Content-Type"]
  }

  tags = {
    Name    = "alma-api"
    Project = "ALMA Cloud"
    Team    = "ALMA Cloud"
  }
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "alma-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Fires when alma-list-products Lambda has errors"

  dimensions = {
    FunctionName = "alma-list-products"
  }

  tags = {
    Name    = "alma-lambda-errors"
    Project = "ALMA Cloud"
    Team    = "ALMA Cloud"
  }
}