#!/bin/bash
yum update -y
yum install -y httpd mod_proxy
systemctl enable httpd
systemctl start httpd

cat <<EOF > /etc/httpd/conf.d/proxy.conf
<VirtualHost *:80>
  ProxyPass / http://${internal_alb_dns}/
  ProxyPassReverse / http://${internal_alb_dns}/
</VirtualHost>
EOF

systemctl restart httpd
