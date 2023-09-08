data "tls_certificate" "github_thumbprint" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_policy" "ecs_ecr_policy" {
  name        = "ecr_ecs_policy"
  description = "Policy that gives permissions on specific ECS and ECR resources"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:*"
        ],
        Resource = [
          var.ecs_cluster_arn,   # ARN of the ECS cluster
          replace(var.ecs_task_arn, "/:\\d+$/", ":*")   # ARN of the ECS task definition
          # Add ARNs of other ECS resources if needed
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:*"
        ],
        Resource = [
          var.ecr_repository_arn   # Replace 'example' with your ECR repository resource name
        ]
      }
    ]
  })
}


data "aws_iam_policy_document" "gha_trust_policy" {
  statement {
    actions = [
      "sts:TagSession",
      "sts:AssumeRoleWithWebIdentity"
    ]

    # We use StringLike on the Arn to control this
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:liatrio/keyless-workflow-demo:environment:production"]
    }
  }
}

resource "aws_iam_role" "gha_role" {
  name                = "gha_role"
  assume_role_policy  = data.aws_iam_policy_document.gha_trust_policy.json
  managed_policy_arns = [aws_iam_policy.ecs_ecr_policy.arn]
}
