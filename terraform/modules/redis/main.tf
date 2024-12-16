# This module sets up an AWS ElastiCache for Redis instance, providing a caching solution for the application.

module "redis" {
  # Source of the module
  # Using the official ElastiCache module from Terraform AWS Modules registry, which simplifies the configuration process.
  source = "terraform-aws-modules/elasticache/aws"

  # Specify the caching engine
  # Indicates that the ElastiCache engine to be used is Redis, which is a high-performance, in-memory data store.
  engine = "redis"
}
