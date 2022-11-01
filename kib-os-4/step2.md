Настроим маршрутизацию исходящего трафика через Egress Gateway

`connection.yml`{{open}}

`connection.env`{{open}}

`oc process -f connection.yml --param-file connection.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

Повторим проверку подключения к PostgreSQL. Подключение успешно

`oc exec $(oc get pods -o name -l app=postgresql-client | head -n 1) -- bash -c 'pg_isready -h $PG_ADDRESS -p 5432'`{{execute}}

В логах istio-proxy, что запрос к внешнему узлу был перенаправлен на порт 3000 Egress Gateway

`oc logs $(oc get pods -o name -l app=postgresql-client | head -n 1) -c istio-proxy`{{execute}}

`[2022-10-26T21:38:37.330Z] "- - -" 0 - - - "-" 81 132 7 - "-" "-" "-" "-" "10.128.3.186:3000" outbound|3000||ci00000000-test-egress.sbercode-a0d2f9cf-6928-42c4-98d5-97cf225f9674-work.svc.cluster.local 10.128.3.184:33136 172.30.109.223:5432 10.128.3.184:53994 - -`

В логах Egress Gateway видим обращение к внешнему узлу

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}

`[2022-10-26T21:38:37.331Z] "- - -" 0 - - - "-" 81 132 6 - "-" "-" "-" "-" "172.30.109.223:5432" outbound|5432||pg-2b30cd45-725e-4871-aa00-0cdab2cffd95.apps.sbc-okd.pcbltools.ru 10.128.3.186:34786 10.128.3.186:3000 10.128.3.184:33136 - -`
