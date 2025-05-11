# Define the provider (AWS)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or the latest version you prefer
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}