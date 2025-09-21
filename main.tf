module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  subnets  = var.subnets
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id

  security_groups = {
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

resource "aws_security_group_rule" "alb_public_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.sg.sg_ids["alb_public"]
}

resource "aws_security_group_rule" "proxy_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.sg.sg_ids["proxy"]
  source_security_group_id = module.sg.sg_ids["alb_public"]
}

resource "aws_security_group_rule" "alb_private_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.sg.sg_ids["alb_private"]
  source_security_group_id = module.sg.sg_ids["proxy"]
}

resource "aws_security_group_rule" "backend_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.sg.sg_ids["backend"]
  source_security_group_id = module.sg.sg_ids["alb_private"]
}
resource "aws_security_group_rule" "proxy_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]   
  security_group_id = module.sg.sg_ids["proxy"]
}


resource "aws_security_group_rule" "backend_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.sg.sg_ids["backend"]
  source_security_group_id = module.sg.sg_ids["proxy"]
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "proxy_ec2" {
  source              = "./modules/ec2"
  instance_count      = 2
  ami_id              = data.aws_ami.amazon_linux.id
  instance_type       = var.proxy_instance_type
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [module.sg.sg_ids["proxy"]]
  key_name            = "jenkins"
  associate_public_ip = true
  internal_alb_dns    = module.private_alb.alb_dns
  role                = "proxy"
  tags = {
    Role = "proxy"
  }
}

module "backend_ec2" {
  source              = "./modules/ec2"
  instance_count      = 2
  ami_id              = data.aws_ami.amazon_linux.id
  instance_type       = var.backend_instance_type
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.sg.sg_ids["backend"]]
  key_name            = "jenkins"
  associate_public_ip = false
  bastion_hosts       = module.proxy_ec2.public_ips

  role                = "backend"
  
  tags = {
    Role = "backend"
  }

}

module "public_alb" {
  source          = "./modules/alb"
  name            = "public-alb"
  internal        = false
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnet_ids
  security_groups = [module.sg.sg_ids["alb_public"]]
  instance_ids    = module.proxy_ec2.instance_ids
}


module "private_alb" {
  source          = "./modules/alb"
  name            = "private-alb"
  internal        = true
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnet_ids
  security_groups = [module.sg.sg_ids["alb_private"]]
  instance_ids    = module.backend_ec2.instance_ids
}
