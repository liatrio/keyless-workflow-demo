#!/bin/bash

set -e  # Exit script on any error

# Define AWS region and profile
AWS_REGION="us-east-2"
AWS_PROFILE="admin-sandbox"

# Check if aws-vault is installed
if command -v aws-vault &> /dev/null
then
    # aws-vault is installed, use it for AWS credentials
    AWS_VAULT_PREFIX="aws-vault exec $AWS_PROFILE --"
else
    # aws-vault is not installed, proceed without it
    AWS_VAULT_PREFIX=""
fi

# Step 1: Apply terraform for ECR
pushd terraform
${AWS_VAULT_PREFIX} terragrunt apply -target=aws_ecr_repository.knowledgeshare_ui_ecr --auto-approve

# Step 2: Get the ECR repository URL
ECR_REPO_URL=$(${AWS_VAULT_PREFIX} terragrunt output -raw ecr_repository_url)
popd

# Step 3: Build docker image
docker buildx build --platform linux/amd64 -t keyless-workflow-demo .

# Step 4: Authenticate Docker to the ECR registry
${AWS_VAULT_PREFIX} aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URL

# Step 5: Tag and push docker image to ECR
docker tag keyless-workflow-demo:latest $ECR_REPO_URL:latest
docker push $ECR_REPO_URL:latest

pushd terraform
# Step 6: Apply the rest of the terraform
${AWS_VAULT_PREFIX} terragrunt apply --auto-approve
