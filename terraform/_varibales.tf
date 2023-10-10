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

# variable "ecs_cluster_arn" {
#   description = "ARN of the ECS cluster"
#   type        = string
# }

# variable "ecs_task_arn" {
#   description = "ARN of the ECS task definition"
#   type        = string
# }

# variable "ecr_repository_arn" {
#   description = "ARN of the ECR repository"
#   type        = string
# }

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

# variable "ecs_service_arn" {
#   description = "ARN of the ECS service"
#   type        = string
# }
