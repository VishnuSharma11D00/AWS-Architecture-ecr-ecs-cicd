locals {
  bucket_name = "cc-tf-my-app-VS11d00"
  table_name = "ccTfDemo"
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
}
