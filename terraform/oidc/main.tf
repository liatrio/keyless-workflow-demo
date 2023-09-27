## Uncomment this block of code if you are testing this in a personal aws account
## This is a central resource that in my org is not managed via terraform and thus
## including this resouce causes issues.
# resource "aws_iam_openid_connect_provider" "github" {
#   url = "https://token.actions.githubusercontent.com"

#   # All roles go here.
#   # You can find these in the audience of the Github OIDC tokens
#   client_id_list = ["sts.amazonaws.com"]

#   thumbprint_list = [
#     data.tls_certificate.github_thumbprint.certificates[0].sha1_fingerprint
#   ]
# }

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
          var.ecs_service_arn,   # ARN of the ECS service
          replace(var.ecs_task_arn, "/:\\d+$/", ":*")   # ARN that matches all task-definition revisions for the task definition created in this repo
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
          var.ecr_repository_arn   # Replace 'example' with your ECR repository resource name
        ]
      }
    ]
  })
}

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
      # This value will need to be updated to work on a fork of this repo
      # https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#example-subject-claims
      values   = ["repo:liatrio/keyless-workflow-demo:environment:demo"]
    }
  }
}

resource "aws_iam_role" "gha_role" {
  name                = "gha_role"
  assume_role_policy  = data.aws_iam_policy_document.gha_trust_policy.json
  managed_policy_arns = [aws_iam_policy.ecs_ecr_policy.arn, aws_iam_policy.terraform_read.arn]
}
