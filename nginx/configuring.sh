#!/bin/bash

#change kernel configuration
sudo cp ./sysctl/777-properties-for-nginx.conf /etc/sysctl.d/ ;
sudo sysctl -p;
sudo sysctl --system;

#ssl cert generate
openssl genrsa -out ./ssl/tls.key 2048 && \
openssl req -new -key ./ssl/tls.key -out ./ssl/tls.csr -config ./ssl/req.conf && \
openssl req -x509 -sha256 -nodes -new -key ./ssl/tls.key -out ./ssl/CAcert.crt -config ./ssl/req.conf && \
openssl x509 -sha256 -CAcreateserial -req -days 365 -in ./ssl/tls.csr -extfile ./ssl/req.conf -CA ./ssl/CAcert.crt -CAkey ./ssl/tls.key -out ./ssl/tls.crt;


cp ./ssl/CAcert.crt /etc/ssl;
cp ./ssl/tls.key /etc/ssl;
cp ./ssl/tls.crt /etc/ssl;
#Configure and start nginx server
cp ./nginx.conf /etc/nginx/ ;
nginx -t;
nginx -s reload;
