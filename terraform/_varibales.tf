variable "name" {
  type        = string
  description = "The Repository Name"
  default     = "keyless-workflow-demo"
}

variable "tfstate_bucket" {}

variable "tfstate_dynamodb_table" {}

variable "aws_region" {}
