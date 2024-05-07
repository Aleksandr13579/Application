#!/bin/bash

#change kernel configuration
sudo cp ./sysctl/777-propetries-for-nginx.conf /etc/sysctl.d/ ;
sudo sysctl -p;
sudo sysctl --system;

#ssl cert generate
openssl genrsa -out tls.key 2048 && \
openssl req -new -key tls.key -out tls.csr -config ./ssl/req.conf && \
openssl req -x509 -sha256 -nodes -new -key key.key -out CAcert.crt -config ./ssl/req.conf && \
openssl x509 -sha256 -CAcreateserial -req -days 365 -in tls.csr -extfile ./ssl/req.conf -CA CAcert.crt -CAkey tls.key -out tls.crt;

#Configure and start nginx server
cp ./nginx.conf /etc/nginx/ ;
nginx -t;
nginx -s reload;
