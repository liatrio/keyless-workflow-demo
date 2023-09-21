resource "aws_ecr_repository" "knowledgeshare_ui_ecr" {
  name                 = var.name
  force_delete         = true
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
