module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"  # Use the correct version of the module

  identifier          = var.db_name         # Database instance identifier
  engine              = "mysql"            # MySQL database engine
  engine_version      = "8.0"              # MySQL version
  instance_class      = "db.t3.micro"      # Database instance size
  allocated_storage   = 20                 # Initial storage size in GB
  max_allocated_storage = 100              # Autoscaling limit for storage

  username            = var.db_username    # Database master username
  password            = var.db_password    # Database master password
  publicly_accessible = false              # Ensure the DB is private

  subnet_ids          = var.subnet_ids     # Subnet IDs for RDS deployment
  vpc_security_group_ids = var.security_group_ids  # Security groups for RDS

  skip_final_snapshot = true               # Skip snapshot on deletion (optional)
}

resource "aws_security_group" "rds_sg" {
  # Security group configuration for RDS
}
