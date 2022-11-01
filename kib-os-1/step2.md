В соответствии с требованями УЭК весь исходящий из проекта АС трафик должен проходить через Egress Gateway в проекте АС.
Для запуска своего Egress Gateway нам потребуются:

* Имя проекта
* Имя Control Plane Istio, к которой подключен проект
* Название сервиса Egress. Название должно содержать КЭ АС, это требование сопровождения Istio
* Перечень портов, используемых для организаци трафика через Egress Gateway. Все порты должны быть объявлены в Service
  Egress Gateway

Получим имя проекта

`oc project -q`{{execute}}

Получим имя Control Plane

`oc describe project $(oc project -q) | grep member-of | head -n 1 | cut -d '=' -f2`{{execute}}

Заполните полученные параметры в файле

`egress-params.env`{{open}}

Создадим Deployment Egress Gateway

`oc process -f egress-template.yml --param-file egress-params.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

В логах пода Egress Gateway необходимо дождаться сообщения

`Envoy Proxy is ready`

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}
