Для объявления возможности подключения к внешнему ресурсу используется объект
Istio [ServiceEntry](https://istio.io/latest/docs/reference/config/networking/service-entry/)

Изучите шаблон ServiceEntry для настройки TCP-соединения с внешним узлом в файле, обратите внимание на комментарии

`easy.yml`{{open}}

Применим настройки ServiceEntry с параметрами из файла

`easy-params.env`{{open}}

`oc process -f easy.yml --param-file easy-params.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

Повторим проверку, соединение успешно

`oc exec $(oc get pods -o name -l app=client | head -n 1) -- sh -c 'curl -v http://$EASY_ADDRESS'`{{execute}}

В логах контейнера istio-proxy видим прямое обращение к внешнему узлу

`oc logs $(oc get pods -o name -l app=client | head -n 1) -c istio-proxy`{{execute}}
