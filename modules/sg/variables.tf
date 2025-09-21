variable "vpc_id" {
  type        = string
  description = "VPC ID for security groups"
}

variable "security_groups" {
  description = "Map of SG definitions"
  type = map(object({
    name        = string
    description = string
  }))
}
