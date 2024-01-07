Создадим серверный сертификат, подписанный собственным удостоверяющим центром.
Для создания серитификата нам потребуются:

* файл с описанием параметров сертификата (server.cnf). Для серверного сертификата, кроме DN, требуется заполнять секцию alt_names (доменные имена узлов, которые смогут использовать созданный сертификат)
* закрытый ключ

`./server/server.cnf`{{open}}

Создадим закрытый ключ.

`openssl genrsa -out server/key.pem 2048`{{execute}}

Сформиируем запрос на сертификат.

`openssl req -config server/server.cnf -key server/key.pem -new -sha256 -out server/csr.pem`{{execute}}

Создадим сертификат с использованием собственного удостоверяющего центра.
При создании сертификата потребуется подтвержение.

`openssl ca -config ca/intermediate/intermediate.cnf -passin pass:qwe123 -extensions server_cert -days 365 -notext -md sha256 -in server/csr.pem -out server/crt.pem`{{execute}}

Проверим созданный сертификат.

`openssl x509 -noout -text -in server/crt.pem`{{execute}}

В поле Issuer указана информация о промежуточном сертификате, в поле Subject - параметры из файла client.cnf.

`Issuer: C = RU, ST = MOW, L = MOW, O = SBRF, CN = test-intermediate`

`Subject: C = RU, ST = MOW, O = SBRF, CN = ci00000000-test-ingress`
