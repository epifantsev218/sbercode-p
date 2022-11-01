Применим настройки Simple TLS подключения. Simple TLS - односторонняя проверка клиентом сертификата сервера

Изучите шаблон для настройки Simple TLS на Ingress Gateway в файле, обратите внимание на комментарии

`simple.yml`{{open}}

Документация по объектам Openshift и Istio, использущимся для настройки маршрутизации:

* [Route](https://docs.openshift.com/container-platform/4.7/networking/routes/route-configuration.html)
* [Gateway](https://istio.io/latest/docs/reference/config/networking/gateway/)
* [Virtual Service](https://istio.io/latest/docs/reference/config/networking/virtual-service/)

Уточните параметры Simple TLS соединения

`simple-params.env`{{open}}

Значение параметра SIMPLE_URL должно присутствовать в alt_names сертификата

`oc process -f simple.yml --param-file simple-params.env -o yaml > conf.yml
oc apply -f conf.yml
export $(cat simple-params.env | xargs)`{{execute}}

Выполним запрос. В результате увидим ошибку SSL Handshake, т.к. клиент не доверяет самоподписанному серверному
сертификату

`curl -v https://${SIMPLE_URL}`{{execute}}

`curl: (60) SSL certificate problem: self signed certificate`

Добавим сертификат в перечень доверенных и запрос будет обработан успешно

`curl -v --cacert ./certs/crt.pem https://${SIMPLE_URL}`{{execute}}

В логах Ingress Gateway видим успешный запрос через порт 3000

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}

`[2022-10-26T20:32:23.981Z] "GET / HTTP/2" 200 - via_upstream - "-" 0 44 5 5 "10.128.0.1" "curl/7.85.0" "11b3e582-f84e-92f0-8e3b-11af2b4b4c0b" "asd.apps.sbc-okd.pcbltools.ru" "10.128.3.171:8080" outbound|8080||server.sbercode-f581046a-24c0-403b-8540-5f829d9abd3a-work.svc.cluster.local 10.128.3.173:56232 10.128.3.173:3000 10.128.0.1:48910 asd.apps.sbc-okd.pcbltools.ru -`
