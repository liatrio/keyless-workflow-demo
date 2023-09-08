resource "aws_ecs_cluster" "knowledgeshare_ui_ecs_cluster" {
  name = "knowledgeshare-demo"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "knowledgeshare_ui_task" {
  family = "knowledgeshare-service"
  container_definitions = jsonencode([{
    name = "knowledgeshare-ui"
    image = "${aws_ecr_repository.knowledgeshare_ui_ecr.repository_url}:latest"
    memory = 512
    essential = true
    portMappings = [
      {
        containerPort = 8080
        hostPort = 80
      }
    ]
  }])
}

resource "aws_ecs_service" "knowledgeshare_ui_service" {
  name = "knowledgeshare_ui"
  cluster = aws_ecs_cluster.knowledgeshare_ui_ecs_cluster.id
  task_definition = aws_ecs_task_definition.knowledgeshare_ui_task.arn
  desired_count = 2
  force_new_deployment = true
  # iam_role        = aws_iam_role.foo.arn
  # depends_on      = [aws_iam_role_policy.foo]

}
