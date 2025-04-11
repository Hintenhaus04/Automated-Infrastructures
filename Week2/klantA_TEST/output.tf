# Output block to expose the public IP addresses of the instances
output "instance_public_ips" {
  description = "Public IP-adressen van de instances"
  value       = module.server.public_ips
}
