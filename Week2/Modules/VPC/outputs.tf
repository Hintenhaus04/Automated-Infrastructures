output "vpc_id" {
  description = "ID van de VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID van de Subnet"
  value       = aws_subnet.this.id
}

output "internet_gateway_id" {
  description = "ID van de Internet Gateway"
  value       = aws_internet_gateway.this.id
}
