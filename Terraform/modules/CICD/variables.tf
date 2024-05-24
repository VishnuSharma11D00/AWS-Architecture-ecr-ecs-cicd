#codestar connection
variable "codestar_connection_name" {
  description = "codestar connection name"
}
variable "codestar_connection_arn" {
  description = "codestar connection arn"
}


# S3 for artifacts codepipeline
variable "artifact_store_bucket_name" {
  description = "S3 bucket for storing CodePipeline artifacts"
  type        = string
}


## Codebuild project variables

variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

/* the environment variables */
variable "env_region" {
  description = "environment region"
  default = "us-east-1"
}
variable "env_account_id" {
  description = "AWS account_id"
  type = number
}
variable "image_repo_name" {
  description = "ecr repo name"
}
variable "container_name" {
  description = "task container name"
}
variable "ecr_repo_url" {
  description = "URL of the ECR repository"
}

variable "image_tag" {
  description = ":latest"
}

variable "github_owner" {
  description = "git hub owner"
}
variable "github_repo" {
  description = "code build git hub repo name"
}

variable "github_repo_link" {
  description = "github repo https link"
}

# Codepipeline variables

variable "codepipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
}
variable "github_branch" {
  description = "git hub branch name"
}


# Code Deploy variables
variable "ecs_cluster_name" {
  description = "ecs cluster name for code Deploy"
}

variable "ecs_service_name" {
  description = "ecs service name for code"
}