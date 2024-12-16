# Output the name servers for the hosted zone
# These name servers need to be updated in the domain registrar for Route 53 to manage the domain.
output "route53_zone_name_servers" {
  value       = aws_route53_zone.main.name_servers # Returns the name servers of the hosted zone
  description = "Route 53 name servers for the domain" # Description for clarity
}