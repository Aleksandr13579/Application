#!/bin/bash

touch /etc/yum.repos.d/nginx.repo;

#add nginx repo
cat <<EOF > touch /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

#install and start nginx
yum update && yum install nginx && nginx -v;
systemctl enable nginx;
systemctl start nginx;

#unlock http port in firewall
firewall-cmd --zone=public --add-service=http

#configuring nginx
chmod 755 configuring.sh;
./configuring.sh