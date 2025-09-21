resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_ids, count.index % length(var.subnet_ids))
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip
  tags = merge(var.tags, { Name = "${var.role}-${count.index}" })


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/jenkins.pem") 
    host = self.associate_public_ip_address ? self.public_ip : self.private_ip
    bastion_host        = length(var.bastion_hosts) > 0 ? element(var.bastion_hosts, 0) : null
    bastion_user        = "ec2-user"
    bastion_private_key = file("~/.ssh/jenkins.pem")
  }

  provisioner "remote-exec" {
  when       = create
  on_failure = continue

  inline = [
    "case \"${var.role}\" in",

    "proxy)",
    "  sudo yum update -y",
    "  sudo yum install -y httpd mod_proxy",
    "  sudo systemctl enable httpd",
    "  sudo systemctl start httpd",
    "  echo '<VirtualHost *:80>' | sudo tee /etc/httpd/conf.d/proxy.conf",
    "  echo '  ProxyPass / http://${var.internal_alb_dns}/' | sudo tee -a /etc/httpd/conf.d/proxy.conf",
    "  echo '  ProxyPassReverse / http://${var.internal_alb_dns}/' | sudo tee -a /etc/httpd/conf.d/proxy.conf",
    "  echo '</VirtualHost>' | sudo tee -a /etc/httpd/conf.d/proxy.conf",
    "  sudo systemctl restart httpd",
    "  ;;",

    "backend)",
    "  sleep 30",
    "  sudo yum update -y",
    "  sudo yum install -y httpd",
    "  sudo systemctl enable httpd",
    "  sudo systemctl start httpd",
    "  echo \"Hello from Backend - Private IP: $(hostname -I)\" | sudo tee /var/www/html/index.html",
    "  ;;",

  
    "*)",
    "  echo 'No role-specific setup for ${var.role}'",
    "  ;;",

    "esac"
  ]
  }

}