variable "my_app_cluster_name" {
  description = "My App ecs cluster name"
  type = string
}

variable "my_app_task_name" {
  description = "name of task definition"
  default = "my_app_task_definition"
}

variable "ecr_repo_url" {
  description = "the output of ecr url"
}

variable "image_tag" {
  description = "the version of the ecr image"
}

variable "container_port" {
  description = "port of container task definition"
} 
#get these from creating a local.tf file outside cuz you'll use the same values for alb. port = 3000


variable "ecs_task_execution_role_name" {
  description = "ecs task execution role name"
}

variable "alb_name" {
  description = "name of alb"
}

variable "public_subnet_ids" {
  description = "output from public-subnet1 id"
  type = list(string)
}


variable "target_group_name" {
  description = "name of target group"
}

variable "my_vpc" {
  description = "output from vpc id"
}

variable "my_app_service_name" {
  description = "ecs service name"
}

variable "private_subnet_ids" {
  description = "output form private subnet"
  type = list(string)
}
