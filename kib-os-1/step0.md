Для проверки соединения развернем образ с клиентом Kafka

`kafka-client.yml`{{open}}

`oc apply -f kafka-client.yml`{{execute}}

Дождемся, пока под с клиентом запустится

`oc get pods -l name=kafka-client`{{execute}}

Проверим подключение к брокеру Kafka, запустим команду для получения версий API брокера из workload контейнера пода клиента
`oc exec $(oc get pods -o name -l name=kafka-client | head -n 1) -- bash -c 'kafka-broker-api-versions.sh --bootstrap-server $KAFKA_ADDRESS'`{{execute}}

В логах istio-proxy видим ошибку с кодом UH

`oc logs $(oc get pods -o name -l name=kafka-client | head -n 1) -c istio-proxy`{{execute}}

Изучите формат логов Envoy Proxy и описание кодов ошибок
на [странице](https://www.envoyproxy.io/docs/envoy/latest/configuration/observability/access_log/usage)

`UH: No healthy upstream hosts in upstream cluster in addition to 503 response code.`

`2022-10-25T20:37:07.830Z] "- - -" 0 UH - - "-" 0 0 0 - "-" "-" "-" "-" "-" - - 178.170.196.65:9092 10.128.3.43:56440 - -`
