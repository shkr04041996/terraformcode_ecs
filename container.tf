resource "aws_ecs_cluster" "main" {
  name = "${var.config.projectName}-cluster-${var.config.environment}"
}
resource "aws_iam_role" "ECSTaskExecutionRole" {
  name_prefix = var.name_prefix

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Environment = "aws-ia-fargate"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.config.projectName}-task-${var.config.environment}"
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ECSTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ECSTaskExecutionRole.arn
  container_definitions = jsonencode([{
    name        = "${var.config.projectName}-container-${var.config.environment}"
    image       = "${var.image_url}"
    essential   = var.essential
    environment = [{
      name  = "environment"
      value = "dev"
    }]
    portMappings = [{
      protocol      = var.protocol
      containerPort = var.container_port
      hostPort      = var.hostPort
    }]
  }])
}

/*resource "aws_ecs_task_definition" "service" {
  family = "${var.config.projectName}-task-${var.config.environment}"
  network_mode             = var.network_mode
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "${var.image}:latest"
      cpu       = 10
      memory    = 1536
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
  ])

}*/

resource "aws_ecs_service" "main" {
  name                               = "${var.config.projectName}-service-${var.config.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  launch_type                        = var.launch_type
  scheduling_strategy                = var.scheduling_strategy

  network_configuration {
    security_groups  = var.securityGroupIds
    subnets          = var.subnetIds
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:537712062995:targetgroup/Container/12f25121ac795830"
    container_name   = "${var.config.projectName}-container-${var.config.environment}"
    container_port   = var.container_port
  }

  /*lifecycle {
   ignore_changes = [task_definition, desired_count]
 }*/
}
