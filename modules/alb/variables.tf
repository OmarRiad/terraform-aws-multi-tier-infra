variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "internal" {
  description = "Whether the LB is internal"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "Subnets to launch the ALB in"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for the ALB"
  type        = list(string)
}

variable "target_type" {
  description = "Target type (instance, ip, lambda)"
  type        = string
  default     = "instance"
}

variable "target_port" {
  description = "Port the target group listens on"
  type        = number
  default     = 80
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "instance_ids" {
  description = "Instances to register in the target group"
  type        = list(string)
}

variable "listener_port" {
  description = "Listener port for the ALB"
  type        = number
  default     = 80
}
