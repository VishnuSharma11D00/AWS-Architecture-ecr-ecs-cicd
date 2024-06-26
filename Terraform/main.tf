
module "tfstate" {
  source = "./modules/tfstate"

  bucket_name = local.bucket_name
  table_name = local.table_name
}

module "ecr" {
  source = "./modules/ecr"
  
  ecr_repo_name = local.ecr_repo_name
}

#after this is created, ssh into ec2 instance and run git clone your dockerfilr, go to Dockerfile directory 
#Go to ECR page in aws console for push commands and copy-paste ecr commands to build docker image and push to ecr

module "VPC" {
  source = "./modules/VPC"

  availability_zone1 = local.availability_zone1
  availability_zone2 = local.availability_zone2
  /*
  I gave a tfvars file in vpc module
  vpc_cidr_block =  ""
  pubsub1_cidr = ""
  pubsub2_cidr = ""
  prisub1_cidr = ""
  prisub2_cidr = ""
  */
}

module "ecs" {
  source = "./modules/ecs"

  my_app_cluster_name = local.my_app_cluster_name

  my_app_task_name = local.my_task_name
  ecr_repo_url = module.ecr.repository_url

  image_tag = local.image_tag
  container_port = local.container_port
  ecs_task_execution_role_name = local.ecs_task_execution_role_name
  public_subnet_ids = module.VPC.public_subnet_ids
  private_subnet_ids = module.VPC.private_subnet_ids
  
  alb_name = local.alb_name
  target_group_name = local.target_group_name
  my_vpc = module.VPC.vpc_id
  
  my_app_service_name = local.my_app_service_name
  # create_service = var.create_service

  depends_on = [module.VPC]
}


module "cicd" {
  source = "./modules/CICD"
  
  codestar_connection_arn = local.codestar_connection_arn
  codestar_connection_name = local.codestar_connection_name
  
  artifact_store_bucket_name = local.artifact_store_bucket_name

  codebuild_project_name = local.codebuild_project_name
 
  env_region = local.env_region
  env_account_id = local.AWS_ACCOUNT_ID
  image_repo_name = local.ecr_repo_name
  container_name = local.my_task_name
  ecr_repo_url = module.ecr.repository_url
  image_tag = local.image_tag
  github_owner = local.github_owner
  github_repo = local.github_repo
  github_repo_link = local.github_repo_link

  codepipeline_name = local.codepipeline_name
  github_branch = local.github_branch
  

  ecs_cluster_name = local.my_app_cluster_name
  ecs_service_name = local.my_app_service_name

  depends_on = [module.VPC]

}

