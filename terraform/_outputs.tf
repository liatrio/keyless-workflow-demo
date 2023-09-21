output "ecr_repository_url" {
  value       = aws_ecr_repository.knowledgeshare_ui_ecr.repository_url
  description = "URL of the ECR repository"
}

output "ecr_repository_arn" {
  value       = aws_ecr_repository.knowledgeshare_ui_ecr.arn
  description = "ARN of the ECR repository"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.knowledgeshare_ui_ecs_cluster.arn
  description = "ARN of the ECS cluster"
}

output "ecs_task_arn" {
  value       = data.aws_ecs_task_definition.current_task.arn
  description = "ARN of the ECS task definition"
}

output "ecs_service_arn" {
  value       = aws_ecs_service.knowledgeshare_ui_service.id
  description = "ARN of the ECS Service"
}
