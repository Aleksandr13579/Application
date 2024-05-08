#!/bin/bash

#install packages for connect to apt repository
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring;

#import official key for authentication apt packages
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null;

gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg;

#connecting the apt repository for the stable version of nginx
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list;

#install nginx
sudo apt update;
sudo apt install nginx;
nginx -v;
systemctl enable nginx;
systemctl start nginx;

#configuring nginx
chmod 755 configuring.sh;
./configuring.sh