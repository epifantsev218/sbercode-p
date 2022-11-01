Mutual TLS подразумевает взаимную проверку клиентом и сервером сертификатов друг друга

Изучите шаблон для настройки Mutual TLS на Ingress Gateway в файле, отличие от Simple - блок tls объекта Gateway

`mutual.yml`{{open}}

Уточните параметры Mutual TLS соединения

`mutual-params.env`{{open}}

Значение параметра MUTUAL_URL должно присутствовать в alt_names сертификата и не должно совпадать с SIMPLE_URL

`oc process -f mutual.yml --param-file mutual-params.env -o yaml > conf.yml
oc apply -f conf.yml
export $(cat mutual-params.env | xargs)`{{execute}}

При попытке вызова без клиентского сертификата получим ошибку SSL Handshake

`curl -v --cacert ./certs/crt.pem https://${MUTUAL_URL}`{{execute}}

`curl: (56) OpenSSL SSL_read: error:1409445C:SSL routines:ssl3_read_bytes:tlsv13 alert certificate required, errno 0`

Отправим запрос с сертификатом клиента

`curl -v --cacert ./certs/crt.pem --cert ./certs/crt.pem --key ./certs/key.pem https://${MUTUAL_URL}`{{execute}}

В логах Ingress Gateway видим успешный запрос через порт 3001

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}

`[2022-10-26T20:35:06.260Z] "GET / HTTP/2" 200 - via_upstream - "-" 0 44 2 1 "10.130.0.1" "curl/7.85.0" "0806b7d1-0dcf-9c37-83ba-125c501c595a" "zxc.apps.sbc-okd.pcbltools.ru" "10.128.3.171:8080" outbound|8080||server.sbercode-f581046a-24c0-403b-8540-5f829d9abd3a-work.svc.cluster.local 10.128.3.173:45190 10.128.3.173:3001 10.130.0.1:57346 zxc.apps.sbc-okd.pcbltools.ru -`
