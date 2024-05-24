# codestar connection - github
  resource "aws_codestarconnections_connection" "github_connection" {
    name          = var.codestar_connection_name
    provider_type = "GitHub"

  }

# IAM Role for CodePipeline
  resource "aws_iam_role" "codepipeline_role" {
    name = "codepipeline_role_name"
    assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json
  }

  resource "aws_iam_role_policy" "codepipeline_policy" {
    name   = "codepipeline_policy"
    role   = aws_iam_role.codepipeline_role.id
    policy = data.aws_iam_policy_document.codepipeline_policy.json
  }


# IAM role for CodeBuild
  resource "aws_iam_role" "codebuild_role" {
    name               = "codebuild_role"
    assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
  }
  resource "aws_iam_role_policy" "codebuild_policy" {
    role   = aws_iam_role.codebuild_role.name
    policy = data.aws_iam_policy_document.codebuild_policy.json
  }

#s3 bucket for storing artifacts
  resource "aws_s3_bucket" "pipeline_artifacts" {
    bucket = var.artifact_store_bucket_name
  }
  resource "aws_s3_bucket_versioning" "pipeline_artifacts_versioning" {
    bucket = aws_s3_bucket.pipeline_artifacts.id
    versioning_configuration {
      status = "Enabled"
    }
  }
  resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_artifacts_encryption" {
      bucket = aws_s3_bucket.pipeline_artifacts.id
      rule {
          apply_server_side_encryption_by_default {
              sse_algorithm = "AES256"
          }
      }
    }


# CodeBuild Project
  resource "aws_codebuild_project" "terraform" {
    name          = var.codebuild_project_name
    description   = "Build project for Terraform"
    build_timeout = "15"

    service_role = aws_iam_role.codebuild_role.arn

    artifacts {
      type = "CODEPIPELINE"
    }
    
    environment {
      compute_type                = "BUILD_GENERAL1_SMALL"
      image                       = "aws/codebuild/standard:4.0"
      type                        = "LINUX_CONTAINER"
      image_pull_credentials_type = "CODEBUILD"

      
      environment_variable {
        name  = "REPOSITORY_URI"
        value = var.ecr_repo_url
      }
      environment_variable {
        name  = "IMAGE_TAG"
        value = var.image_tag
      }

      environment_variable {
        name = "AWS_DEFAULT_REGION"
        value = var.env_region
      }
      environment_variable {
        name = "AWS_ACCOUNT_ID"
        value = var.env_account_id
      }
      environment_variable {
        name = "IMAGE_REPO_NAME"
        value = var.image_repo_name
      }
      environment_variable {
        name = "CONTAINER_NAMES"
        value = var.container_name
      }

    }
    source {
      type      = "CODEPIPELINE"
      location = var.github_repo_link
      buildspec = "buildspec.yml"
    }
  }

# Codepipeline
  resource "aws_codepipeline" "cicd_pipeline" {
    name = var.codepipeline_name
    role_arn = aws_iam_role.codepipeline_role.arn
    pipeline_type = "V2"
    
    artifact_store {
      location = aws_s3_bucket.pipeline_artifacts.bucket

      type = "S3"
    }

    stage {
      name = "Source"

      action {
        name = "Source"
        category = "Source"
        owner = "AWS"
        provider = "CodeStarSourceConnection"
        version = "1"
        output_artifacts = ["source_output"]

        configuration = {
          ConnectionArn  = var.codestar_connection_arn
          FullRepositoryId = "${var.github_owner}/${var.github_repo}"
          BranchName     = var.github_branch
        }
      }
    }
    stage {
      name = "Build"

      action {
        name = "Build"
        category = "Build"
        owner = "AWS"
        provider = "CodeBuild"
        input_artifacts = ["source_output"]
        output_artifacts = ["build_output"]
        version = "1"

        configuration = {
          ProjectName = aws_codebuild_project.terraform.name
        }
      }
    }

    stage {
      name = "Deploy"
      action {
        name = "Deploy"
        category = "Deploy"
        owner = "AWS"
        provider = "ECS"
        input_artifacts = ["build_output"]
        version = "1"

        configuration = {
          ClusterName = var.ecs_cluster_name
          ServiceName = var.ecs_service_name
          FileName = "imagedefinitions.json"
        }
      }
    }

  }
