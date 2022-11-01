Настроим Mutual TLS для исходящих запросов. Для Mutual TLS кроме цепочек УЦ необходимо указать открытую и закрытую части
сертификата

Изучите шаблон для настройки Mutual TLS на Egress Gateway в файле, обратите внимание на комментарии

`mutual.yml`{{open}}

`mutual-params.env`{{open}}

`oc process -f mutual.yml --param-file mutual-params.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

Проверим подключение

`oc exec $(oc get pods -o name -l app=client | head -n 1) -- sh -c 'curl -v http://$MUTUAL_ADDRESS'`{{execute}}

В логах istio-proxy, что запрос к внешнему узлу был перенаправлен на порт 3001 Egress Gateway

`oc logs $(oc get pods -o name -l app=client | head -n 1) -c istio-proxy`{{execute}}

`[2022-10-23T18:29:53.969Z] "GET / HTTP/1.1" 200 - via_upstream - "-" 0 44 20 20 "-" "curl/7.64.0" "14c51ea4-a2e7-94fa-9e8e-45f5a9a7ef52" "b9e93687-47e6-4ff6-a64c-7fa635e08ef7.apps.sbc-okd.pcbltools.ru" "10.128.2.35:3001" outbound|3001||ci00000000-test-egress.sbercode-a06d6040-d4da-456c-ae55-2725df9438f0-work.svc.cluster.local 10.128.2.33:57396 240.240.0.3:80 10.128.2.33:50008 - -`

В логах Egress Gateway видим обращение к порту 443 внешнего узла

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}

`[2022-10-23T18:29:53.969Z] "GET / HTTP/1.1" 200 - via_upstream - "-" 0 44 13 13 "10.128.2.33" "curl/7.64.0" "14c51ea4-a2e7-94fa-9e8e-45f5a9a7ef52" "b9e93687-47e6-4ff6-a64c-7fa635e08ef7.apps.sbc-okd.pcbltools.ru" "178.170.196.65:443" outbound|443||b9e93687-47e6-4ff6-a64c-7fa635e08ef7.apps.sbc-okd.pcbltools.ru 10.128.2.35:56616 10.128.2.35:3001 10.128.2.33:57396 - -`