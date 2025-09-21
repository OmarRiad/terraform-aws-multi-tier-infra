#!/bin/bash
sleep 30
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

echo "Hello from Backend - Private IP: $(hostname -I)" > /var/www/html/index.html
