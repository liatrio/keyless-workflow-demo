# Purpose: Create an OIDC provider for Github Actions to use to assume a role in AWS
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  # Only create the provider if it doesn't already exist
  count = length(data.aws_iam_openid_connect_provider.github) == 0 ? 1 : 0

  url = "https://token.actions.githubusercontent.com"

  # You can find these in the audience of the Github OIDC tokens
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    data.tls_certificate.github_thumbprint.certificates[0].sha1_fingerprint
  ]
}

data "tls_certificate" "github_thumbprint" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

# Purpose: Create a policy that gives permissions on specific ECS and ECR resources
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
          aws_ecs_cluster.knowledgeshare_ui_ecs_cluster.arn,   # ARN of the ECS cluster
          aws_ecs_service.knowledgeshare_ui_service.id,   # ARN of the ECS service
          replace(data.aws_ecs_task_definition.current_task.arn, "/:\\d+$/", ":*")   # ARN that matches all task-definition revisions for the task definition created in this repo
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition"
          ],
        Resource = [ "*" ]
      },
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole"
          ],
        Resource = [ "*" ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:*"
        ],
        Resource = [
          aws_ecr_repository.knowledgeshare_ui_ecr.arn
        ]
      }
    ]
  })
}

# Purpose: Create a policy that gives permissions to read the backend s3 bucket the tf state file is stored
resource "aws_iam_policy" "terraform_read" {
  name        = "terraform_read"
  description = "Policy that gives permissions to access the backend s3 bucket the tf state file is stored"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TerraformStateS3ReadPermissions",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.tfstate_bucket}",
                "arn:aws:s3:::${var.tfstate_bucket}/*"
            ]
        },
        {
            "Sid": "TerraformStateDynamoDBReadPermissions",
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:DescribeTable",
            ],
            "Resource": "arn:aws:dynamodb:${var.aws_region}:*:table/${var.tfstate_dynamodb_table}"
        }
    ]
  })
}

# Purpose: Create a role that Github Actions can assume to deploy to ECS
data "aws_iam_policy_document" "gha_trust_policy" {
  statement {
    actions = [
      "sts:TagSession",
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_organization}/keyless-workflow-demo:environment:demo"]
    }
  }
}

# Purpose: Create a role that Github Actions can assume to deploy to ECS
resource "aws_iam_role" "gha_role" {
  name                = "gha_role"
  assume_role_policy  = data.aws_iam_policy_document.gha_trust_policy.json
  managed_policy_arns = [aws_iam_policy.ecs_ecr_policy.arn, aws_iam_policy.terraform_read.arn]
}
