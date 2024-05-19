resource "aws_ecs_cluster" "my_app_cluster_name" {
  name = var.my_app_cluster_name
}

resource "aws_ecs_task_definition" "my_app_task_definition" {
  family = var.my_app_task_name
  container_definitions = jsonencode([
    {
      name      = var.my_app_task_name
      image     = "${var.ecr_repo_url}:${var.image_tag}"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])
requires_compatibilities = ["FARGATE"]
network_mode = "awsvpc"
memory = 512
cpu = 256
execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}


resource "aws_iam_role" "ecs_task_execution_role" {
    name = var.ecs_task_execution_role_name
    assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachement" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "load_balancer_sg" {

  vpc_id = var.my_vpc

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "application_load_balancer" {
  name = var.alb_name
  subnets = var.public_subnet_ids
  security_groups = ["${aws_security_group.load_balancer_sg.id}"]
}


resource "aws_lb_target_group" "target_group" {
  name = var.target_group_name
  port = var.container_port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.my_vpc
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }  
}

resource "aws_ecs_service" "my_app_service" {
  name = var.my_app_service_name
  cluster = aws_ecs_cluster.my_app_cluster_name.id
  task_definition = aws_ecs_task_definition.my_app_task_definition.arn
  launch_type = "FARGATE"
  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name = aws_ecs_task_definition.my_app_task_definition.family
    container_port = var.container_port
  }



  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = ["${aws_security_group.service_security_group.id}"]
  }
}

resource "aws_security_group" "service_security_group" {
  vpc_id = var.my_vpc
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = ["${aws_security_group.load_balancer_sg.id}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#autoscaling
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.my_app_cluster_name.name}/${aws_ecs_service.my_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_scaling_policy" {
  name               = "ecs-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 50
  }
}
