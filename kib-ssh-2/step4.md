Проверим подключение

`oc exec $(oc get pods -o name -l app=client | head -n 1) -- sh -c 'curl -v http://$MUTUAL_ADDRESS'`{{execute}}

`oc logs $(oc get pods -o name -l app=client | head -n 1) -c istio-proxy`{{execute}}

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}

`oc logs $(oc get pods -o name -l app=server | head -n 1) -c istio-proxy`{{execute}}
