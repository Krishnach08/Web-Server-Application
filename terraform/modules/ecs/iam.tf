# This role is required to allow ECS tasks to interact with AWS services securely.
resource "aws_iam_role" "ecs_task_execution_role" {
  # Name of the IAM role
  name = "ecs-task-execution-role"

  # Define the trust relationship policy document
  # This allows ECS tasks to assume this role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17" # Policy document version
    Statement = [
      {
        # The action allowed is sts:AssumeRole
        Action    = "sts:AssumeRole"
        Effect    = "Allow" # Allow ECS tasks to assume this role
        Principal = { 
          # The ECS tasks service (ecs-tasks.amazonaws.com) is allowed to assume this role
          Service = "ecs-tasks.amazonaws.com" 
        }
      }
    ]
  })
}

# Attach a managed policy to the IAM role
# This policy grants the ECS Task Execution Role permissions needed to interact with other AWS services (e.g., pulling images from ECR, publishing logs to CloudWatch).
resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  # Name of the policy attachment
  name = "ecs-task-execution-policy"

  # Attach the policy to the ECS Task Execution Role created above
  roles = [aws_iam_role.ecs_task_execution_role.name]

  # This policy includes permissions such as accessing Amazon ECR, publishing logs to CloudWatch, and using secrets in AWS Systems Manager Parameter Store.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
