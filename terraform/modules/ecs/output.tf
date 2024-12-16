output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}

output "task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

