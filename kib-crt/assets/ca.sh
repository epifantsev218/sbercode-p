#!/bin/bash -x
PS1=1
source /root/.bashrc

mkdir /root/ca
cd /root/ca
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

openssl genrsa -aes256 -out private/ca.key.pem -passout pass:qwe123 4096
chmod 400 private/ca.key.pem

openssl req -config ca.cnf -key private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem -passout pass:qwe123 -passin pass:qwe123 -subj "/C=RU/ST=MOW/L=MOW/O=SBRF/CN=test-ca"
chmod 444 certs/ca.cert.pem
echo 'Проверка корневого сертификата' >> /root/ca/log.txt
openssl x509 -noout -text -in certs/ca.cert.pem >> /root/ca/log.txt

mkdir /root/ca/intermediate
cd /root/ca/intermediate
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > /root/ca/intermediate/crlnumber
cd /root/ca
openssl genrsa -aes256 -out intermediate/private/intermediate.key.pem -passout pass:qwe123 4096
chmod 400 intermediate/private/intermediate.key.pem
openssl req -config intermediate/intermediate.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -out intermediate/csr/intermediate.csr.pem -passout pass:qwe123 -passin pass:qwe123 -subj "/C=RU/ST=MOW/L=MOW/O=SBRF/CN=test-intermediate"
openssl ca -config ca.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in intermediate/csr/intermediate.csr.pem -out intermediate/certs/intermediate.cert.pem -passin pass:qwe123 -batch
chmod 444 intermediate/certs/intermediate.cert.pem
echo 'Проверка промежуточного сертификата' >> /root/ca/log.txt
openssl x509 -noout -text -in intermediate/certs/intermediate.cert.pem >> /root/ca/log.txt
openssl verify -CAfile certs/ca.cert.pem intermediate/certs/intermediate.cert.pem >> /root/ca/log.txt

cat intermediate/certs/intermediate.cert.pem certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem
chmod 444 intermediate/certs/ca-chain.cert.pem

cd /root