  env_region = "us-east-1"

  bucket_name = "cc-tf-my-app-vs11d00"
  table_name = "ccTfDemo"

  ecr_repo_name = "nodejs-server"
  
  availability_zone1 = "us-east-1a"
  availability_zone2 = "us-east-1b"

  my_app_cluster_name = "my-app-cluster"
  my_task_name = "my-task"
  container_port = 3000
  ecs_task_execution_role_name = "ecs_task_execution_role"
  image_tag = "latest"
  alb_name = "my-app-alb"
  target_group_name = "my-app-tg"
  my_app_service_name = "my-app-service"


  codestar_connection_arn = "arn:aws:codestar-connections:..."
  codestar_connection_name = "your codestar connection name"

  artifact_store_bucket_name = "artifact-store-bucket-vs11d00"

  AWS_ACCOUNT_ID = your account id (type -  number)
  codebuild_project_name ="my_codebuild_project"
  github_owner = "VishnuSharma11d00"
  github_repo = "Nodejs-server"
  github_repo_link = "https://github.com/VishnuSharma11D00/Nodejs-server.git"
  codepipeline_name = "my_codepipeline"
  github_branch = "main"
  
}
