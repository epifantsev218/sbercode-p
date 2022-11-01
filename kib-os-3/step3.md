Настроим Simple TLS для исходящих запросов. Требуется указать только цепочки доверенных УЦ. Т.к.
используем самоподписанный сертификат, то используем его вместо цепочек

Изучите шаблон для настройки Simple TLS на Egress Gateway в файле, обратите внимание на комментарии

`simple.yml`{{open}}

`simple-params.env`{{open}}

`oc process -f simple.yml --param-file simple-params.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

Проверим подключение. Обратите внимание, что приложение по-прежнему обращается к порту 80, а уже Egress Gateway - к
порту 443

`oc exec $(oc get pods -o name -l app=client | head -n 1) -- sh -c 'curl -v http://$SIMPLE_ADDRESS'`{{execute}}

В логах istio-proxy, что запрос к внешнему узлу был перенаправлен на порт 3000 Egress Gateway

`oc logs $(oc get pods -o name -l app=client | head -n 1) -c istio-proxy`{{execute}}

`[2022-10-23T18:28:33.789Z] "GET / HTTP/1.1" 200 - via_upstream - "-" 0 44 28 27 "-" "curl/7.64.0" "56140728-4722-972f-afaa-299e00837e1a" "349bc685-0338-48e8-bb74-414c2fd9f301.apps.sbc-okd.pcbltools.ru" "10.128.2.35:3000" outbound|3000||ci00000000-test-egress.sbercode-a06d6040-d4da-456c-ae55-2725df9438f0-work.svc.cluster.local 10.128.2.33:50174 240.240.0.2:80 10.128.2.33:56948 - -`

В логах Egress Gateway видим обращение к порту 443 внешнего узла

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}

`[2022-10-23T18:28:33.790Z] "GET / HTTP/1.1" 200 - via_upstream - "-" 0 44 21 20 "10.128.2.33" "curl/7.64.0" "56140728-4722-972f-afaa-299e00837e1a" "349bc685-0338-48e8-bb74-414c2fd9f301.apps.sbc-okd.pcbltools.ru" "178.170.196.65:443" outbound|443||349bc685-0338-48e8-bb74-414c2fd9f301.apps.sbc-okd.pcbltools.ru 10.128.2.35:49182 10.128.2.35:3000 10.128.2.33:50174 - -`