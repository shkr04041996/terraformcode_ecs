### Output of Permission ###
variable "execution_role_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
variable "task_role_arn" {
  type    = string
  default = "arn:aws:iam::353211646521:role/ecsTaskExecutionRole-dev"
}
### Output of ALB ###
variable "target_group_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:us-east-1:353211646521:targetgroup/MMM-infra-dev-target-group/83624f32de1d975c"
}
 

output "ECS_cluster_ID" {
  value = aws_ecs_cluster.main.id
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.main.arn
}
