# This module sets up an ECS (Elastic Container Service) cluster in AWS, enabling the deployment and management of containerized applications.
module "ecs" {
  # Source of the module
  # Using the official ECS module from Terraform AWS Modules registry for pre-configured best practices and ease of use.
  source = "terraform-aws-modules/ecs/aws"

  # Name of the ECS cluster
  # Dynamically assigns the name of the ECS cluster based on the value provided in the "cluster_name" variable.
  cluster_name = var.cluster_name
}

resource "aws_security_group" "ecs_sg" {
  # Security group configuration for ECS
}