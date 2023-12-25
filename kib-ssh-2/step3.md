`./ca/intermediate/certs/ca-chain.cert.pem`{{open}}

`./server/key.pem`{{open}}

`./server/crt.pem`{{open}}

`oc create secret generic ingress-certs --from-file=key.pem="./server/key.pem" --from-file=crt.pem="./server/crt.pem" --from-file=ca.pem="./ca/intermediate/certs/ca-chain.cert.pem"`{{execute}}

`oc delete $(oc get pods -o name | grep ingress | head -n 1) --force --grace-period=0`{{execute}}

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}
