variable "name" {
  type        = string
  description = "The Repository Name"
  default     = "keyless-workflow-demo"
}

variable "github_organization" {
  type        = string
  description = "The GitHub Organization"
  default     = "liatrio"
}

variable "tfstate_bucket" {
  description = "The S3 bucket to store the Terraform state file"
  type        = string
}

variable "tfstate_dynamodb_table" {
  description = "The DynamoDB table to lock the Terraform state file"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}
