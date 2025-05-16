# REST-API-with-Lambda

# Simple REST API with AWS Lambda Backend (Terraform)

This project demonstrates the creation and deployment of a basic RESTful API on AWS using Terraform for Infrastructure as Code (IaC) and AWS Lambda for the serverless backend.

## Overview

This API provides a simple endpoint that, upon receiving an HTTP request, triggers an AWS Lambda function written in Python. The Lambda function processes the request and returns a JSON response. AWS API Gateway acts as the entry point for the API, handling routing and request/response management. Terraform is used to define and provision all the necessary AWS resources in an automated and repeatable manner.

## Architecture

+-----------------+     +-----------------+     +---------------------+
| Client (e.g.,   | --> | AWS API Gateway | --> | AWS Lambda Function | --> Response (JSON)
| curl, browser)  |     +-----------------+     +---------------------+
+-----------------+

## Prerequisites

* **AWS Account:** You need an active AWS account.
* **Terraform:** Ensure you have Terraform installed on your local machine. You can find installation instructions on the [official Terraform website](https://www.terraform.io/downloads).
* **AWS CLI:** The AWS Command Line Interface should be configured with your AWS credentials. You can find instructions on the [AWS CLI website](https://aws.amazon.com/cli/).
* **Python 3.x:** If you intend to understand or modify the Lambda function code.
* **ZIP Utility:** To create the initial Lambda function deployment package (though Terraform now handles this).

## Getting Started

1.  **Clone the Repository (if you haven't already):**
    ```bash
    git clone [YOUR_REPOSITORY_URL]
    cd [YOUR_REPOSITORY_DIRECTORY]
    ```

2.  **Navigate to the Terraform Directory (if applicable):**
    ```bash
    cd terraform
    ```

3.  **Initialize Terraform:**
    ```bash
    terraform init
    ```
    This command initializes the Terraform working directory and downloads any necessary provider plugins (in this case, the AWS provider).

4.  **Plan the Infrastructure:**
    ```bash
    terraform plan
    ```
    This command creates an execution plan, showing you exactly what AWS resources Terraform will create, modify, or delete. Review the plan to ensure it aligns with your expectations.

5.  **Apply the Terraform Configuration:**
    ```bash
    terraform apply
    ```
    This command applies the changes required to reach the desired state defined in your Terraform configuration. You will be prompted to confirm the action before Terraform proceeds. Type `yes` to confirm.

6.  **Retrieve the API Endpoint:**
    After the `terraform apply` command completes successfully, the output will typically include the invoke URL of your API Gateway. Look for an output variable named something like `api_gateway_invoke_url`. Copy this URL.

## Testing the API

You can test your API using various HTTP clients like `curl`, Postman, or your web browser.

**Example using `curl`:**

Replace `YOUR_API_GATEWAY_INVOKE_URL` with the actual invoke URL you obtained from the Terraform output.

* **GET Request (if your Lambda handles GET):**
    ```bash
    curl YOUR_API_GATEWAY_INVOKE_URL/items
    ```

* **POST Request (if your Lambda handles POST and expects data):**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '{"key": "value"}' YOUR_API_GATEWAY_INVOKE_URL/items
    ```

    Adjust the endpoint (`/items` in this example) and the HTTP method and body according to how you configured your API Gateway routes and Lambda function logic.

## Cleaning Up

To avoid incurring unnecessary AWS costs, you should destroy the resources created by Terraform when you are finished with this project.

1.  **Navigate to the Terraform Directory (if applicable):**
    ```bash
    cd terraform
    ```

2.  **Destroy the Infrastructure:**
    ```bash
    terraform destroy
    ```
    This command will prompt you to confirm the deletion of all the AWS resources managed by this Terraform configuration. Type `yes` to confirm.

## Project Structure

.
├── README.md
├── terraform/
│   ├── main.tf           # Main Terraform configuration file
│   ├── variables.tf      # Defines input variables
│   ├── outputs.tf        # Defines output values
│   └── lambda/           # Directory containing the Lambda function code
│       └── lambdafunction.py # Python code for the Lambda function


## Key Skills Demonstrated

* Infrastructure as Code (IaC) with Terraform
* AWS API Gateway setup and configuration
* AWS Lambda function creation and deployment
* Integration between API Gateway and Lambda
* Basic understanding of RESTful APIs
* AWS IAM role and policy creation for secure resource access

## Further Enhancements

* Implement different HTTP methods (GET, POST, PUT, DELETE).
* Integrate with a database (e.g., AWS DynamoDB) for persistent data storage.
* Add request validation to API Gateway.
* Implement authentication and authorization for the API.
* Set up custom domain names and SSL certificates for the API Gateway.
* Implement more robust error handling in the Lambda function.
* Use environment variables for configuration.

