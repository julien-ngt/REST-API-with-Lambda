# 1. Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "api_gateway_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}

# 2. Attach the AWSLambdaBasicExecutionRole policy to the IAM role
resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = [aws_iam_role.lambda_role.name]
}

# Create the deployment package (ZIP file)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./lambda" # Path to the directory containing your lambda function
  output_path = "lambdafunction.py.zip"
}

# 3. Create a simple Lambda function
resource "aws_lambda_function" "my_lambda_function" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  filename         = "lambdafunction.py.zip"
  source_code_hash = filebase64sha256("./lambda/lambdafunction.py.zip")
  # Environment variables
  environment {
    variables = {
      MESSAGE = var.lambda_environment_message
    }
  }
}



# 4. Create an IAM role for API Gateway to invoke Lambda
resource "aws_iam_role" "api_gateway_role" {
  name = "api_gateway_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}

# 5. Attach a policy to the API Gateway role to allow invoking the Lambda function
resource "aws_iam_policy_attachment" "api_gateway_policy_attachment" {
  name       = "api-gateway-policy-attachment"
  policy_arn = aws_iam_policy.api_gateway_policy.arn
  roles      = [aws_iam_role.api_gateway_role.name]
}

resource "aws_iam_policy" "api_gateway_policy" {
  name        = "api_gateway_lambda_invoke_policy"
  description = "Allows API Gateway to invoke the Lambda function"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "lambda:InvokeFunction",
        Resource = aws_lambda_function.my_lambda_function.arn,
        Effect   = "Allow"
      }
    ]
  })
}

# 6. Create the API Gateway
resource "aws_api_gateway_rest_api" "my_api_gateway" {
  name        = var.api_gateway_name
  description = "A simple REST API with a Lambda backend"
}

# 7. Create a resource in the API Gateway
resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  path_part   = var.api_gateway_resource_path
}

# 8. Create a GET method for the resource
resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# 9. Set up the integration between the GET method and the Lambda function
resource "aws_api_gateway_integration" "my_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id             = aws_api_gateway_resource.my_resource.id
  http_method             = aws_api_gateway_method.my_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  credentials             = aws_iam_role.api_gateway_role.arn
  uri                     = aws_lambda_function.my_lambda_function.invoke_arn
  #request_parameters = {
  #  "integration.request.path.proxy" = "method.request.path.proxy"
  #}
}

# 10. Deploy the API Gateway
resource "aws_api_gateway_deployment" "my_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id

}

#10 BIS
resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.my_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id
  stage_name    = "dev"
}

# 11. Create a Lambda Permission to allow API Gateway to invoke the function
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
}

