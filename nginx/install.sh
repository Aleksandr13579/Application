sudo cp ./sysctl/777-propetries-for-nginx.conf /etc/sysctl.d/ ;
sudo sysctl -p;
sudo sysctl --system;

#ssl cert generate
openssl genrsa -out new_tls.key 2048 && \
openssl req -new -key new_tls.key -out new_tls.csr -config req.conf && \
openssl req -x509 -sha256 -nodes -new -key new_key.key -out new_tls.crt -config req.conf && \
openssl x509 -sha256 -CAcreateserial -req -days 365 -in new_tls.csr -extfile req.conf -CA new_tls.crt -CAkey new_tls.key -out final.crt
