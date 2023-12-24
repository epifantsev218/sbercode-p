`./client/client.cnf`{{open}}

`openssl genrsa -aes256 -out client/key.pem 2048`{{execute}}

`openssl req -config client/client.cnf -key client/key.pem -new -sha256 -out client/csr.pem`{{execute}}

`openssl ca -config ca/intermediate/intermediate.cnf -passin pass:qwe123 -extensions client_cert -days 365 -notext -md sha256 -in client/csr.pem -out client/crt.pem`{{execute}}

`openssl x509 -noout -text -in client/crt.pem`{{execute}}
