provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "todo_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "todo-api-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.todo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "todo-api-public-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.todo_vpc.id

  tags = {
    Name = "todo-api-igw"
  }
}

resource "aws_security_group" "lambda_sg" {
  name        = "todo-api-lambda-sg"
  description = "Security group for Todo API Lambda function"
  vpc_id      = aws_vpc.todo_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "todo_api_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "todo_api" {
  filename         = "../publish.zip"
  function_name    = "todo-api"
  role             = aws_iam_role.lambda_role.arn
  handler          = "TodoApi::TodoApi.LambdaEntryPoint::FunctionHandlerAsync"
  runtime          = "dotnet8"

  environment {
    variables = {
      ASPNETCORE_ENVIRONMENT = "Production"
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.public.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

resource "aws_apigatewayv2_api" "lambda" {
  name          = "todo-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id
  name   = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "todo_api" {
  api_id = aws_apigatewayv2_api.lambda.id
  integration_uri    = aws_lambda_function.todo_api.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "todo_api" {
  api_id = aws_apigatewayv2_api.lambda.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.todo_api.id}"
}
