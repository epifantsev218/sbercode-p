Для Ingress Gateway Secret должен состоять из трех файлов:

* Цепочек доверенных удостоверяющих центров (ca-chain.cert.pem)
* Закрытой части серверного сертификата (key.pem)
* Открытой части серверного сертификата (crt.pem)

`./ca/intermediate/certs/ca-chain.cert.pem`{{open}}

`./server/key.pem`{{open}}

`./server/crt.pem`{{open}}

Создаем Secret.

`oc create secret generic ingress-certs --from-file=key.pem="./server/key.pem" --from-file=crt.pem="./server/crt.pem" --from-file=ca.pem="./ca/intermediate/certs/ca-chain.cert.pem"`{{execute}}

Перезапускаем Pod Ingress Gateway. Deployment, ссылающийся на созданный Secret был создан заранее.

`oc delete $(oc get pods -o name | grep ingress | head -n 1) --force --grace-period=0`{{execute}}

В логах Ingress Gateway необходимо дождаться сообщения

`Envoy Proxy is ready`

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}
