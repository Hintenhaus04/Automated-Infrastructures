output "instance_ids" {
  description = "IDs van de aangemaakte instances"
  value       = aws_instance.this[*].id
}

output "public_ips" {
  description = "Public IP-adressen van de instances"
  value       = aws_instance.this[*].public_ip
}
