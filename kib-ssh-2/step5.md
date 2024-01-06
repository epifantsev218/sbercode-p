Для работы с хранилищами в формате JKS требуется утилита keytool, входящая в состав JRE. Установим актуальную версию JRE.

`sudo apt update`{{execute}}

`sudo apt install default-jre`{{execute}}

`java -version`{{execute}}

Хранилища сертификатов Java делятся на 2 вида: KeyStore и TrustStore (описание на <a target="_blank" href="https://docs.oracle.com/cd/E19509-01/820-3503/ggffo/index.html">странице</a>).
KeyStore (хранилище ключей) используется для хранения как сертификатов, так и связанных с ними закрытых ключей (private key).
В TrustStore хранятся сертификаты удостоверяющих центров, которым мы должны доверять.

В задании требуется создать хранилище TrustStore, содержащее корневой и промежуточный сертификат нашего удостоверяющего центра.

Создаем новое хранилище в формате JKS и добавляем в него корневой сертификат. При создании хранилища потребуется ввести пароль. Его нужно запомнить, т.к. он будет нужен для всех действий с хранилищем.

`keytool -import -v -trustcacerts -alias ca -file ./ca/certs/ca.cert.pem -keystore truststore.jks`{{execute}}

В созданное хранилище добавляем промежуточный сертификат.

`keytool -import -v -trustcacerts -alias intermediate -file ./ca/intermediate/certs/intermediate.cert.pem -keystore truststore.jks`{{execute}}

Проверяем созданное хранилище.

`keytool -v -list -keystore truststore.jks`{{execute}}

Оно должно содержать 2 сертификата.

`Your keystore contains 2 entries`

Корневой

`Alias name: ca

Creation date: Jan 6, 2024

Entry type: trustedCertEntry

Owner: CN=test-ca, O=SBRF, L=MOW, ST=MOW, C=RU

Issuer: CN=test-ca, O=SBRF, L=MOW, ST=MOW, C=RU`

Промежуточный

`Alias name: intermediate
Creation date: Jan 6, 2024
Entry type: trustedCertEntry
Owner: CN=test-intermediate, O=SBRF, ST=MOW, C=RU
Issuer: CN=test-ca, O=SBRF, L=MOW, ST=MOW, C=RU`
