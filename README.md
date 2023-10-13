# OIDC Demo

This repo is intended to be a self contained demo of how to leverage OIDC in a workflow to authenticate with AWS and deploy a simple containerized application. This repo contains:

* Simple Next-js application
* Terraform module to create all required infrastructure (VPC, ECR, ECS Fargate Cluster, and an application LB)
* Dockerfile to build the application
* A GitHub Actions workflow to demonstrate deploying the docker image to an ECS cluster
## Setup
### For MacOS
run `brew bundle` to install dependencies

### For Windows (untested)
```π
# Install AWS CLI
choco install awscli

# Install Terraform
choco install terraform

# Install Terragrunt
choco install terragrunt
```
### Configure AWS CLI
Follow these instructions to configure AWS CLI. https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html


## Initialize
When running this at home you will need to provide your own 'organization' so that the trust policy on the IAM role will allow your workflow to run.
This can be done by running `init.sh <organization>`. Simply replace `<organization>` with your username. So if you fork the repo and the url for your repo is,
`https://github.com/jburns24/keyless-workflow-demo` then you would run `init.sh jburns24`.

After this finishes you will see a DNS name output as `front_end_dns_name`. Copy that DNS name and hit it in a browser. If you get a 503 Service Not Available you were too fast, just give it a min and refresh.

After the init script runs copy the output of `gha_role_arn`. Then go to GitHub > Settings > Secrets and variables > Actions. In here create a *Variable* named `OIDC_ROLE` and popualte it with the value you copied for `gha_role_arn`.


## Clean up
To save on money make sure you do not leave your AWS resources up and running. To do this navigate to the `terraform` directory and run `terragrunt destroy`. You will be prompted to confirm the deletion and that is it!

Hope you find this informative and if there are bugs please open and issue and I will try to address them. Pull requests are also welcome!
