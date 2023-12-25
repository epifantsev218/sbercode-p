`./ca/intermediate/certs/ca-chain.cert.pem`{{open}}

`./client/key.pem`{{open}}

`./client/crt.pem`{{open}}

`oc create secret generic egress-certs --from-file=key.pem="./client/key.pem" --from-file=crt.pem="./client/crt.pem" --from-file=ca.pem="./ca/intermediate/certs/ca-chain.cert.pem"`{{execute}}

`oc delete $(oc get pods -o name | grep egress | head -n 1) --force --grace-period=0`{{execute}}

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}
