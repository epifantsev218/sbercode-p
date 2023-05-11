Для подключения к внешнему узлу нужно добавить свой отрытый ключ в файл authorized_keys

`cat ~/.ssh/id_rsa.pub >  ~/.ssh/authorized_keys`{{execute}}

`cat ~/.ssh/authorized_keys`{{execute}}

Теперь мы можем подключиться к внешнему узлу с помощью SSH ключа и пароль не требуется

`ssh localhost -f 'pwd'`{{execute}}