# This block configures the AWS provider, which is required for managing AWS resources.
provider "aws" {
  # Specify the AWS region for resource deployment
  region = var.region
}

# This module creates a Virtual Private Cloud (VPC), which serves as the foundational network for other resources.
module "vpc" {
  # Specify the source of the module
  source      = "./modules/vpc"

  # Pass the CIDR block to the VPC module
  cidr_block  = var.cidr_block   # Passed dynamically via the root variable "cidr_block"
}

module "ecs" {
  # Specify the source of the module
  source       = "./modules/ecs"

  # Pass the cluster name to the ECS module
  # The "cluster_name" variable defines the name of the ECS cluster.
  cluster_name = var.cluster_name  # Dynamically set via the root variable "cluster_name"
}

# This module creates a Relational Database Service (RDS) instance for managing MySQL databases.
module "rds"{
  # Specify the source of the module
  source  = "./modules/rds"

  # Pass the database name to the RDS module
  db_name = var.db_name  # Dynamically set via the root variable "db_name"
}

# This module provisions an Amazon ElastiCache instance for Redis, which serves as the caching layer for the application.
module "redis" {
  # Specify the source of the module
  source = "./modules/redis"
}

# Example of referencing ECS security group ID
resource "aws_some_resource" "example" {
  security_group_ids = [module.ecs.security_group_id]
  # Other resource configurations
}
