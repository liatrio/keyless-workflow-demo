remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "keyless-workflow-demo"
    key     = "keyless-workflow-demo/terraform.tfstate"

    region                = "us-west-2"
    dynamodb_table        = "tflocks"
    disable_bucket_update = true

    # Permissions thing
    skip_bucket_versioning = true

    encrypt = true
  }
}

# terraform {
#   source = ".//tf"
# }
