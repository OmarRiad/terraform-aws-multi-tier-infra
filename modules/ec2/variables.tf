variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_ids" {
  description = "Subnets where instances will be launched"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups to attach"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the instances"
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "User data script for provisioning"
  type        = string
  default     = ""
}
variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = false
}


variable "role" {
  description = "Role of the instance (proxy or backend)"
  type        = string
}


variable "internal_alb_dns" {
  description = "Private ALB DNS (only needed for proxy role)"
  type        = string
  default     = ""
}
variable "bastion_hosts" {
  description = "Public IPs of bastion (proxy) instances to use for SSH into private instances"
  type        = list(string)
  default     = []
}
