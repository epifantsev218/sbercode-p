Для объявления возможности подключения к внешнему ресурсу используется объект
Istio <a target="_blank" href="https://istio.io/latest/docs/reference/config/networking/service-entry/">Service Entry</a>

Изучите шаблон ServiceEntry для настройки TCP-соединения с внешним узлом в файле, обратите внимание на комментарии

`easy.yml`{{open}}

Применим настройки ServiceEntry с параметрами из файла

`connection.env`{{open}}

`oc process -f easy.yml --param-file connection.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

Проверим подключение к брокеру Kafka, соединение успешно

`oc exec $(oc get pods -o name -l name=kafka-client | head -n 1) -- bash -c 'kafka-broker-api-versions.sh --bootstrap-server $KAFKA_ADDRESS'`{{execute}}

В логах контейнера istio-proxy видим прямое обращение к брокеру Kafka

`oc logs $(oc get pods -o name -l name=kafka-client | head -n 1) -c istio-proxy`{{execute}}

`[2022-10-18T20:24:03.639Z] "- - -" 0 - - - "-" 85 585 1100 - "-" "-" "-" "-" "172.30.247.31:9092" outbound|9092||kafka.apps.sbc-okd.pcbltools.ru 10.128.2.33:54464 172.30.247.31:9092 10.128.2.33:54460 - -`

Удаляем созданные конфиги

`oc delete serviceentry -l marker=practice`{{execute}}