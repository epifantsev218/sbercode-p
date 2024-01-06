`keytool -genkey -keyalg RSA -alias endeca -keystore keystore.jks -dname "C=RU,ST=MOW,L=MOW,O=SBRF,CN=empty" -keypass qwe123`{{execute}}

`keytool -delete -alias endeca -keystore keystore.jks`{{execute}}

`cat ./client/key.pem ./client/crt.pem | openssl pkcs12 -export -out client.p12`{{execute}}

`keytool -v -importkeystore -srckeystore client.p12 -srcstoretype PKCS12 -destkeystore keystore.jks -deststoretype JKS -alias client`{{execute}}

`keytool -v -list -keystore keystore.jks`{{execute}}

