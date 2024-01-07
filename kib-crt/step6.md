Для создания KeyStore сначала требуется пустое хранилище. Утилита keytool не позволяет создать пустое хранилище, поэтому создаем JKS с самоподписанным сертификатом и сразу удаляем его.
При создании хранилища потребуется ввести пароль. Его нужно запомнить, так как он будет нужен для всех действий с хранилищем.

`keytool -genkey -keyalg RSA -alias endeca -keystore keystore.jks -dname "C=RU,ST=MOW,L=MOW,O=SBRF,CN=empty" -keypass qwe123`{{execute}}

`keytool -delete -alias endeca -keystore keystore.jks`{{execute}}

Для добавления ключевой пары в хранилище JKS сначала сохраним ее в хранилище PKCS12. Для создания хранилища потребуется ввести пароль.

`cat ./client/key.pem ./client/crt.pem ./ca/certs/ca.cert.pem ./ca/intermediate/certs/intermediate.cert.pem | openssl pkcs12 -export -out client.p12`{{execute}}

Добавляем содержимое хранилища PKCS12 в JKS.

`keytool -v -importkeystore -srckeystore client.p12 -srcstoretype PKCS12 -destkeystore keystore.jks -deststoretype JKS -alias client`{{execute}}

Проверяем созданное хранилище.

`keytool -v -list -keystore keystore.jks`{{execute}}

Оно должно содержать одну ключевую пару.

`Your keystore contains 1 entry`

`Alias name: 1`

`Creation date: Jan 7, 2024`

`Entry type: PrivateKeyEntry`

`Certificate chain length: 1`

`Certificate[1]:`

`Owner: CN=ci00000000-test-egress, O=SBRF, ST=MOW, C=RU`

`Issuer: CN=test-intermediate, O=SBRF, L=MOW, ST=MOW, C=RU`
