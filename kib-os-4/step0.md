Для проверки соединения развернем образ с клиентом PostgreSQL

`postgresql-client.yml`{{open}}

`oc apply -f postgresql-client.yml`{{execute}}

Дождемся, пока под с клиентом запустится

`oc get pods -l app=postgresql-client`{{execute}}

Проверяем подключение к экземпляру PostgreSQL из терминала workload-контейнера пода

`oc exec $(oc get pods -o name -l app=postgresql-client | head -n 1) -- bash -c 'pg_isready -h $PG_ADDRESS -p 5432'`{{execute}}

В логах istio-proxy видим ошибку с кодом UH

`oc logs $(oc get pods -o name -l app=postgresql-client | head -n 1) -c istio-proxy`{{execute}}

`UH: No healthy upstream hosts in upstream cluster in addition to 503 response code.`

`[2022-10-26T21:24:06.861Z] "- - -" 0 UH - - "-" 0 0 3 - "-" "-" "-" "-" "-" - - 178.170.196.65:5432 10.128.3.180:60068 - -`
