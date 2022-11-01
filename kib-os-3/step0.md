Запустим экземпляр приложения для отправки HTTP-запросов

`client.yml`{{open}}

`oc apply -f client.yml`{{execute}}

Дождемся, пока под запустится

`oc get pods -l app=client`{{execute}}

Проверим подключение к внешнему узлу из workload-контейнера пода клиента

`oc exec $(oc get pods -o name -l app=client | head -n 1) -- sh -c 'curl -v http://$EASY_ADDRESS'`{{execute}}

В терминале и логе контейнера istio-proxy видим ошибку 502, т.к. соединение не настроено

`oc logs $(oc get pods -o name -l app=client | head -n 1) -c istio-proxy`{{execute}}

`[2022-10-26T22:22:30.254Z] "GET / HTTP/1.1" 502 - direct_response - "-" 0 0 0 - "-" "curl/7.85.0-DEV" "3cc763c2-8d13-9675-be67-f8f665fafaec" "495aa19d-72cd-4f6d-a488-14175d4087d8.apps.sbc-okd.pcbltools.ru" "-" - - 178.170.196.65:80 10.131.0.186:38118 - block_all`