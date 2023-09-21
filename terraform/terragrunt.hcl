remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "keyless-workflow-demo-tfstate"
    key     = "${path_relative_to_include()}/terraform.tfstate"

    region                = "us-east-2"
    dynamodb_table        = "keyless-demo-tflock"
    disable_bucket_update = true

    # Permissions thing
    skip_bucket_versioning = true

    encrypt = true
  }
}

# This block will read all variables in shared.tfvars and append them
# to all terrform commands that accept inputs
terraform {
  extra_arguments "shared_vars" {
    commands = get_terraform_commands_that_need_vars()
    optional_var_files = [
        "${get_parent_terragrunt_dir()}/shared.tfvars",
        "${find_in_parent_folders("shared.tfvars", "ignore")}"
    ]
  }
}
