Изучите шаблон для настройки TCP-соединения с внешним узлом через Egress Gateway в файле, обратите внимание на
комментарии

`correct.yml`{{open}}

Документация по объектам Istio, использущимся для настройки маршрутизации:

* [Gateway](https://istio.io/latest/docs/reference/config/networking/gateway/)
* [Virtual Service](https://istio.io/latest/docs/reference/config/networking/virtual-service/)

Настроим маршрутизацию исходящего трафика через Egress Gateway с параметрами из файла

`connection.env`{{open}}

`oc process -f correct.yml --param-file connection.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

Повторим проверку подключения к Kafka, соединение успешно

`oc exec $(oc get pods -o name -l name=kafka-client | head -n 1) -- bash -c 'kafka-broker-api-versions.sh --bootstrap-server $KAFKA_ADDRESS'`{{execute}}

В логах istio-proxy, что запрос к внешнему узлу был перенаправлен на порт 3000 Egress Gateway

`oc logs $(oc get pods -o name -l name=kafka-client | head -n 1) -c istio-proxy`{{execute}}

`[2022-10-25T21:01:00.331Z] "- - -" 0 - - - "-" 85 585 50690 - "-" "-" "-" "-" "10.131.0.79:3000" outbound|3000||ci00000000-test-egress.sbercode-f4869733-8f72-4aae-a1be-eb097f174235-work.svc.cluster.local 10.128.3.43:44730 172.30.26.92:9092 10.128.3.43:58754 - -`

В логах Egress Gateway видим обращение к внешнему узлу

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}

`[2022-10-25T21:01:00.334Z] "- - -" 0 - - - "-" 85 585 50688 - "-" "-" "-" "-" "172.30.26.92:9092" outbound|9092||kafka.apps.sbc-okd.pcbltools.ru 10.131.0.79:51230 10.131.0.79:3000 10.128.3.43:44730 - -`
