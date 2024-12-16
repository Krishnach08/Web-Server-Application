# Specifies the region where AWS resources will be deployed.
variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Specifies the IP address range for the VPC.
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Specifies the name of the ECS cluster. 
variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "example-cluster"
}

# Specifies the name of the RDS MySQL database.
variable "db_name" {
  description = "The name of the MySQL database"
  type        = string
  default     = "example-db"
}