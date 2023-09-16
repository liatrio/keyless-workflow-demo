resource "aws_ecs_cluster" "knowledgeshare_ui_ecs_cluster" {
  name = "knowledgeshare-demo-clster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

# Fargate requires a task definition role to pull ECR images
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "knowledgeshare_ui_task" {
  family = "keyless-workflow-demo-td"
  network_mode             = "awsvpc" # FARGATE requires awsvpc from what I can tell
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"  # Choose based on your requirements
  memory                   = "2048"  # Choose based on your requirements
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn # FARGATE also requires this role to fetch images from ECR

  container_definitions = jsonencode([{
    name = "knowledgeshare-ui" # TODO make this a variable that can be made into output so we can fetch programatically
    image = "${aws_ecr_repository.knowledgeshare_ui_ecr.repository_url}:latest"
    essential = true
    portMappings = [
      {
        containerPort = 3000
        hostPort = 3000
      }
    ]
  }])
}

resource "aws_ecs_service" "knowledgeshare_ui_service" {
  name = "knowledgeshare_ui"
  launch_type = "FARGATE"
  cluster = aws_ecs_cluster.knowledgeshare_ui_ecs_cluster.id
  task_definition = aws_ecs_task_definition.knowledgeshare_ui_task.arn
  desired_count = 1
  force_new_deployment = true
  network_configuration {
    subnets         = [aws_subnet.keyless_workflow_demo_subnet.id]
    security_groups = [aws_security_group.keyless_workflow_demo_sg.id]
    assign_public_ip = true
  }
  # iam_role        = aws_iam_role.foo.arn
  # depends_on      = [aws_iam_role_policy.foo]

}
