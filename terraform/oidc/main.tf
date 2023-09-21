data "tls_certificate" "github_thumbprint" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

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

# TODO see if you can trim the permissions down such that they match
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AllowListS3ActionsOnTerraformBucket",
#             "Effect": "Allow",
#             "Action": "s3:ListBucket",
#             "Resource": "arn:aws:s3:::admin-terraform-state.liatrio.com"
#         },
#         {
#             "Sid": "AllowGetS3ActionsOnTerraformBucketPath",
#             "Effect": "Allow",
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::admin-terraform-state.liatrio.com/*"
#         }
#     ]
# }
resource "aws_iam_policy" "terraform_read" {
  name        = "terraform_read"
  description = "Policy that gives permissions to access the backend s3 bucket the tf state file is stored"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3BucketPermissions",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.tfstate_bucket}",
                "arn:aws:s3:::${var.tfstate_bucket}/*"
            ]
        },
        {
            "Sid": "DynamoDBLockTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:DescribeTable",
                "dynamodb:DeleteItem"
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
      values   = ["repo:liatrio/keyless-workflow-demo:environment:production"]
    }
  }
}

resource "aws_iam_role" "gha_role" {
  name                = "gha_role"
  assume_role_policy  = data.aws_iam_policy_document.gha_trust_policy.json
  managed_policy_arns = [aws_iam_policy.ecs_ecr_policy.arn, aws_iam_policy.terraform_read.arn]
}
