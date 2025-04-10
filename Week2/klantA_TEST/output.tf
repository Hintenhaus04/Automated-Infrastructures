output "instance_public_ips" {
  description = "Public IP-adressen van de instances"
  value       = module.server.public_ips
}
