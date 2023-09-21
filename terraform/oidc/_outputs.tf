output "gha_role_arn" {
  description = "ARN of the GitHub Action OIDC role"
  value = aws_iam_role.gha_role.arn
}
