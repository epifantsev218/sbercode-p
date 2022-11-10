В соответствии с требованиями УЭК весь входящий в проект АС трафик должен проходить через Ingress Gateway в проекте АС.
Для запуска своего Ingress Gateway нам потребуются:

* Имя проекта
* Имя Control Plane Istio, к которой подключен проект
* Название сервиса Ingress. Название должно содержать КЭ АС, это требование сопровождения Istio
* Перечень портов, используемых для организации трафика через Ingress Gateway. Все порты должны быть объявлены в Service
  Ingress Gateway
* Secret, содержащий серверный сертификат и цепочку доверенных сертификатов. Он должен быть монтирован в
  Deployment Ingress Gateway (см. блоки Volumes и VolumeMounts)

Получим имя проекта

`oc project -q`{{execute}}

Получим имя Control Plane

`oc describe project $(oc project -q) | grep member-of | head -n 1 | cut -d '=' -f2`{{execute}}

Заполните полученные параметры в файле

`ingress-params.env`{{open}}

Изучите шаблон Ingress Gateway 

`ingress-template.yml`{{open}}

Создадим Deployment Ingress Gateway

`oc process -f ingress-template.yml --param-file ingress-params.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

В логах пода Ingress Gateway необходимо дождаться сообщения

`Envoy Proxy is ready`

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}
