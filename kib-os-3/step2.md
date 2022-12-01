Изучите шаблон Egress Gateway в файле. Обратите внимание, что в блоки Volumes и VolumeMounts добавлен Secret с
клиентским сертификатом

`egress-template.yml`{{open}}

Для запуска своего Egress Gateway нам потребуются:

* Имя проекта
* Имя Control Plane Istio, к которой подключен проект
* Название сервиса Egress. Название должно содержать КЭ АС, это требование сопровождения Istio
* Перечень портов, используемых для организации трафика через Egress Gateway. Все порты должны быть объявлены в Service
  Egress Gateway
* Secret, содержащий клиентский сертификат и цепочку доверенных сертификатов

Получим имя проекта

`oc project -q`{{execute}}

Получим имя Control Plane

`oc describe project $(oc project -q) | grep member-of | head -n 1 | cut -d '=' -f2`{{execute}}

Заполните имена проекта и Control Plane в файле

`egress-params.env`{{open}}

Создадим Deployment Egress Gateway

`oc process -f egress-template.yml --param-file egress-params.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

В логах пода Egress Gateway необходимо дождаться сообщения

`Envoy Proxy is ready`

`oc logs $(oc get pods -o name | grep egress | head -n 1)`{{execute}}
