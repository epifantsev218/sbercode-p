Для использования выпущенного сертификата в Egress или Ingress Gateway нужно сохранить его в виде Secret.
Для Egress Gateway Secret должен состоять из трех файлов:

* Цепочек доверенных удостоверяющих центров (ca-chain.cert.pem)
* Закрытой части клиентского сертификата (key.pem)
* Открытой части клиентского сертификата (crt.pem)

`./ca/intermediate/certs/ca-chain.cert.pem`{{open}}

`./client/key.pem`{{open}}

`./client/crt.pem`{{open}}

Создаем Secret.

`oc create secret generic egress-certs --from-file=key.pem="./client/key.pem" --from-file=crt.pem="./client/crt.pem" --from-file=ca.pem="./ca/intermediate/certs/ca-chain.cert.pem"`{{execute}}

Перезапускаем Pod Egress Gateway. Deployment, ссылающийся на созданный Secret был создан заранее.

`oc delete $(oc get pods -o name | grep egress | head -n 1) --force --grace-period=0`{{execute}}

В логах Egress Gateway необходимо дождаться сообщения

`Envoy Proxy is ready`

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}
