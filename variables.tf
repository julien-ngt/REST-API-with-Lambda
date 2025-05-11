variable "aws_region" {
  description = "The AWS region to deploy resources to"
  type        = string
  default     = "us-east-1" # Change to your desired region
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "hello-world-lambda"
}

variable "api_gateway_name" {
  description = "The name of the API Gateway"
  type        = string
  default     = "MySimpleRestAPI"
}

variable "api_gateway_resource_path" {
  description = "The path for the API Gateway resource"
  type        = string
  default     = "hello"
}

variable "lambda_handler" {
  description = "The entry point for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
  default     = "python3.9" # Or a supported runtime
}

variable "lambda_timeout" {
  description = "The execution timeout for the Lambda function, in seconds"
  type        = number
  default     = 10
}

variable "lambda_environment_message" {
  description = "The message stored in the Lambda function's environment variable"
  type        = string
  default     = "Hello from Lambda!"
}