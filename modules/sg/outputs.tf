output "sg_ids" {
  value = { for k, sg in aws_security_group.sgs : k => sg.id }
}
