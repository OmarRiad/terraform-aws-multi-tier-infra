output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "security_group_ids" {
  description = "All SG IDs"
  value       = module.sg.sg_ids
}

output "public_alb_dns" {
  description = "DNS name of the public ALB (entry point)"
  value       = module.public_alb.alb_dns
}

output "private_alb_dns" {
  description = "DNS name of the private ALB (only accessible internally)"
  value       = module.private_alb.alb_dns
}

output "proxy_instance_ids" {
  description = "Proxy instance IDs"
  value       = module.proxy_ec2.instance_ids
}

output "proxy_public_ips" {
  description = "Proxy instance public IPs"
  value       = module.proxy_ec2.public_ips
}

output "backend_instance_ids" {
  description = "Backend instance IDs"
  value       = module.backend_ec2.instance_ids
}

output "backend_private_ips" {
  description = "Backend instance private IPs"
  value       = module.backend_ec2.private_ips
}
