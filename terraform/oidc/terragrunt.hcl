# oidc/terragrunt.hcl

dependency "parent_outputs" {
  config_path = ".."
}

inputs = {
  ecs_cluster_arn      = dependency.parent_outputs.outputs.ecs_cluster_arn
  ecs_task_arn         = dependency.parent_outputs.outputs.ecs_task_arn
  ecr_repository_arn   = dependency.parent_outputs.outputs.ecr_repository_arn
  ecs_service_arn      = dependency.parent_outputs.outputs.ecs_service_arn
}

include {
  path = find_in_parent_folders()
}
