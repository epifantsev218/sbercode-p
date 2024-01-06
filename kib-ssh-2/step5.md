`keytool -import -v -trustcacerts -alias ca -file ./ca/certs/ca.cert.pem -keystore truststore.jks`{{execute}}

`keytool -import -v -trustcacerts -alias ca -file ./ca/certs/ca.cert.pem -keystore truststore.jks`{{execute}}

`keytool -v -list -keystore truststore.jks`{{execute}}
