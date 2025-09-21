resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_ids, count.index % length(var.subnet_ids))
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name
  user_data = var.user_data

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Role"] != "" ? var.tags["Role"] : "ec2-instance"}-${count.index}"
    }
  )

  provisioner "local-exec" {
  when    = create
  command = "if [ -n '${self.public_ip}' ]; then echo '${self.tags.Name} ${self.public_ip}' >> all-ips.txt; fi"
  }

}