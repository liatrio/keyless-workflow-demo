resource "aws_ecs_cluster" "knowledgeshare_ui_ecs_cluster" {
  name = "knowledgeshare-demo-clster"
  setting {
    name  = "containerInsights"
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

resource "aws_cloudwatch_log_group" "keyless_demo_cw" {
  name = "/ecs/keless-workflow-demo"
}

resource "aws_ecs_task_definition" "knowledgeshare_ui_task" {
  family                   = "keyless-workflow-demo-td"
  network_mode             = "awsvpc" # FARGATE requires awsvpc from what I can tell
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn # FARGATE also requires this role to fetch images from ECR

  container_definitions = jsonencode([{
    name      = "knowledgeshare-ui"
    image     = "${aws_ecr_repository.knowledgeshare_ui_ecr.repository_url}:latest"
    essential = true
    portMappings = [
      {
        containerPort = 3000
        hostPort      = 3000
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.keyless_demo_cw.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

data "aws_ecs_task_definition" "current_task" {
  task_definition = aws_ecs_task_definition.knowledgeshare_ui_task.family
}

resource "aws_ecs_service" "knowledgeshare_ui_service" {
  name                 = "knowledgeshare_ui"
  launch_type          = "FARGATE"
  cluster              = aws_ecs_cluster.knowledgeshare_ui_ecs_cluster.id
  task_definition      = data.aws_ecs_task_definition.current_task.arn
  desired_count        = 1
  force_new_deployment = true
  network_configuration {
    subnets          = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
    security_groups  = [aws_security_group.keyless_workflow_demo_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.front_end_target_group.arn
    container_name = "knowledgeshare-ui"
    container_port = 3000
  }
}
