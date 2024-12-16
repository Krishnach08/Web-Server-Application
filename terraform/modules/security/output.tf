# Output the ECS security group ID
output "ecs_security_group_id" {
  value = aws_security_group.ecs_sg.id
}

# Output the RDS security group ID
output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}
