variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "subnets" {
  default = [
    {
      name              = "public-subnet-1"
      cidr              = "10.0.0.0/24"
      map_public_ip     = true
      availability_zone = "us-east-1a"
    },
    {
      name              = "public-subnet-2"
      cidr              = "10.0.2.0/24"
      map_public_ip     = true
      availability_zone = "us-east-1b"
    },
    {
      name              = "private-subnet-1"
      cidr              = "10.0.1.0/24"
      map_public_ip     = false
      availability_zone = "us-east-1a"
    },
    {
      name              = "private-subnet-2"
      cidr              = "10.0.3.0/24"
      map_public_ip     = false
      availability_zone = "us-east-1b"
    }
  ]
}

variable "security_groups" {
  default = {
    alb_public = {
      name        = "alb-public-sg"
      description = "Public ALB SG"
    }
    proxy = {
      name        = "proxy-sg"
      description = "Proxy SG"
    }
    alb_private = {
      name        = "alb-private-sg"
      description = "Private ALB SG"
    }
    backend = {
      name        = "backend-sg"
      description = "Backend SG"
    }
  }
}

variable "proxy_instance_type" {
  default = "t2.micro"
}

variable "backend_instance_type" {
  default = "t2.micro"
}
