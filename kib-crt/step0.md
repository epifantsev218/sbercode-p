Создадим клиентский сертификат, подписанный собственным удостоверяющим центром.
Для создания серитификата нам потребуются:

* файл с описанием параметров сертификата (client.cnf)
* закрытый ключ

`./client/client.cnf`{{open}}

Создадим закрытый ключ.

`openssl genrsa -out client/key.pem 2048`{{execute}}

Сформиируем запрос на сертификат.

`openssl req -config client/client.cnf -key client/key.pem -new -sha256 -out client/csr.pem`{{execute}}

Создадим сертификат с использованием собственного удостоверяющего центра. 
При создании сертификата потребуется подтвержение.

`openssl ca -config ca/intermediate/intermediate.cnf -passin pass:qwe123 -extensions client_cert -days 365 -notext -md sha256 -in client/csr.pem -out client/crt.pem`{{execute}}

Проверим созданный сертификат.

`openssl x509 -noout -text -in client/crt.pem`{{execute}}

В поле Issuer указана информация о промежуточном сертификате, в поле Subject - параметры из файла client.cnf.

`Issuer: C = RU, ST = MOW, L = MOW, O = SBRF, CN = test-intermediate`

`Subject: C = RU, ST = MOW, O = SBRF, CN = ci00000000-test-egress`
