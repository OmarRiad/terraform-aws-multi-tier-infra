variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  description = "List of subnets with type and cidr"
  type = list(object({
    name              = string
    cidr              = string
    map_public_ip     = bool
    availability_zone = string
  }))
}