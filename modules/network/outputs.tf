output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets."
  value       = aws_subnet.app[*].id
}

output "db_subnet_ids" {
  description = "IDs of the isolated database subnets."
  value       = aws_subnet.db[*].id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways (empty when disabled)."
  value       = aws_nat_gateway.this[*].id
}
