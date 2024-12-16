# This variable is used to specify the name of the MySQL database.
variable "db_name" {
  description = "The name of the MySQL database"  # Brief description of the variable
  type        = string                           # Data type for this variable is a string
  default     = "example-db"                     # Default value is "example-db", but it can be overridden
}

# This variable sets the admin username for managing the database.
variable "db_username" {
  description = "The master username for the database"  # Description explaining the purpose of this variable
  type        = string                                 # Data type is a string
  default     = "admin"                                # Default username is "admin"
}

# This variable is used to set a secure password for the database admin user.
variable "db_password" {
  description = "The master password for the database"  # Explains that this is the admin's password
  type        = string                                 # Data type is a string
  default     = "securepassword"                       # Default value for the password (should be updated in production)
  sensitive   = true                                   # Marks the variable as sensitive to hide its value in output
}

# This variable specifies the subnets where the RDS instance will be deployed.
variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"  # Brief description of the purpose
  type        = list(string)                              # Data type is a list of strings
  # No default value is provided, as these must be explicitly defined during deployment
}

# This variable specifies the security groups that will control access to the RDS instance.
variable "security_group_ids" {
  description = "List of security group IDs for the RDS instance"  # Explains its role in securing the database
  type        = list(string)                                      # Data type is a list of strings
  # No default value is provided, requiring explicit input during deployment
}
