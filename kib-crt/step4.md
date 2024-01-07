Проверим подключение

`oc exec $(oc get pods -o name -l app=client | head -n 1) -- sh -c 'curl -v http://$MUTUAL_ADDRESS'`{{execute}}

В логах istio-proxy видим, что запрос к внешнему узлу был перенаправлен на порт 3001 Egress Gateway

`oc logs $(oc get pods -o name -l app=client | head -n 1) -c istio-proxy`{{execute}}

`[2024-01-07T21:33:00.678Z] "GET / HTTP/1.1" 200 - via_upstream - "-" 0 44 26 26 "-" "curl/7.85.0-DEV" "b0307f7f-d65c-9e66-a3b9-913cb92d08ef" "b483732e-7d2c-4046-80f5-27f3aa394b36.apps.sbc-okd.pcbltools.ru" "10.131.0.113:3001" outbound|3001||ci00000000-test-egress.sbercode-a3d95d3e-70de-4062-be7e-a6a1e65dfd81-work.svc.cluster.local 10.131.0.112:35236 240.240.0.1:80 10.131.0.112:55296 - -`

В логах Egress Gateway видим обращение к порту 443 внешнего узла

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}

`[2024-01-07T21:33:00.679Z] "GET / HTTP/1.1" 200 - via_upstream - "-" 0 44 20 20 "10.131.0.112" "curl/7.85.0-DEV" "b0307f7f-d65c-9e66-a3b9-913cb92d08ef" "b483732e-7d2c-4046-80f5-27f3aa394b36.apps.sbc-okd.pcbltools.ru" "178.170.196.65:443" outbound|443||b483732e-7d2c-4046-80f5-27f3aa394b36.apps.sbc-okd.pcbltools.ru 10.131.0.113:53270 10.131.0.113:3001 10.131.0.112:35236 - -`

В логах Ingress Gateway видим успешный запрос через порт 3001

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}

`[2024-01-07T21:34:19.579Z] "GET / HTTP/1.1" 200 - via_upstream - "-" 0 44 1 0 "10.131.0.112,10.128.0.1" "curl/7.85.0-DEV" "27f631f4-1d32-90d2-9f5a-dc762a6d83e5" "b483732e-7d2c-4046-80f5-27f3aa394b36.apps.sbc-okd.pcbltools.ru" "10.131.0.111:8080" outbound|8080||server.sbercode-a3d95d3e-70de-4062-be7e-a6a1e65dfd81-work.svc.cluster.local 10.131.0.114:37182 10.131.0.114:3001 10.128.0.1:33004 b483732e-7d2c-4046-80f5-27f3aa394b36.apps.sbc-okd.pcbltools.ru -`
