# Security group for ECS tasks
resource "aws_security_group" "ecs_sg" {
  # Prefix for the ECS security group name
  name_prefix = "ecs-sg-"

  # The VPC ID where this security group will be created
  vpc_id = var.vpc_id

  # Ingress rule for allowing HTTP traffic (port 80) from anywhere
  ingress {
    from_port   = 80        # Start of the port range
    to_port     = 80        # End of the port range
    protocol    = "tcp"     # Protocol type (TCP in this case)
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from all IP addresses
  }

  # Ingress rule for allowing HTTPS traffic (port 443) from anywhere
  ingress {
    from_port   = 443       # Start of the port range
    to_port     = 443       # End of the port range
    protocol    = "tcp"     # Protocol type (TCP in this case)
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from all IP addresses
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0         # Allow all ports
    to_port     = 0         # Allow all ports
    protocol    = "-1"      # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to all IP addresses
  }

  # Tag the security group for easy identification
  tags = {
    Name = "ecs-security-group"
  }
}

# Security group for RDS (MySQL database)
resource "aws_security_group" "rds_sg" {
  # Prefix for the RDS security group name
  name_prefix = "rds-sg-"

  # The VPC ID where this security group will be created
  vpc_id = var.vpc_id

  # Ingress rule to allow ECS tasks to connect to the database (port 3306)
  ingress {
    from_port        = 3306  # Start of the port range
    to_port          = 3306  # End of the port range
    protocol         = "tcp" # Protocol type (TCP in this case)
    security_groups  = [aws_security_group.ecs_sg.id] # Allow traffic only from the ECS security group
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0         # Allow all ports
    to_port     = 0         # Allow all ports
    protocol    = "-1"      # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to all IP addresses
  }

  # Tag the security group for easy identification
  tags = {
    Name = "rds-security-group"
  }
}
