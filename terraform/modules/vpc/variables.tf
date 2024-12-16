# This variable allows dynamic configuration of the IP address range for the VPC.

variable "cidr_block" {
  # Description of the variable
  # Explains what the variable is used for.
  description = "The CIDR block for the VPC"

  # Type of the variable
  # Ensures that only string values are accepted for this variable.
  type        = string
}
