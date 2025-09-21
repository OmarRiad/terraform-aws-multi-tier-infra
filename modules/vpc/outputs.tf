output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.this : s.id if s.map_public_ip_on_launch]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.this : s.id if !s.map_public_ip_on_launch]
}
