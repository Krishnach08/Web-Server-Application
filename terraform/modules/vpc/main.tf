# This resource sets up an isolated network environment in AWS, where all other resources will reside.

resource "aws_vpc" "main" {
  # Define the CIDR block for the VPC
  # The CIDR block specifies the IP address range for the VPC.
  # The value is dynamically passed from the variable `cidr_block`.
  cidr_block = var.cidr_block

  # Add tags to the VPC
  # Tags are metadata used to identify and manage AWS resources.
  # The "Name" tag assigns the VPC a user-friendly identifier, "main-vpc".
  tags = {
    Name = "main-vpc"
  }
}
