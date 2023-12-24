`./server/server.cnf`{{open}}

`openssl genrsa -aes256 -out server/key.pem 2048`{{execute}}

`openssl req -config server/server.cnf -key server/key.pem -new -sha256 -out server/csr.pem`{{execute}}

`openssl ca -config ca/intermediate/intermediate.cnf -passin pass:qwe123 -extensions server_cert -days 365 -notext -md sha256 -in server/csr.pem -out server/crt.pem`{{execute}}

`openssl x509 -noout -text -in server/crt.pem`{{execute}}
