# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "keyless-workflow-demo-tfstate"
    dynamodb_table = "keyless-demo-tflock"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "us-east-2"
  }
}
