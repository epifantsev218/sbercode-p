По аналогии с Ingress Gateway, работу с сертификатами исходящих запросов также необходимо реализовывать
на уровне Istio. В задании мы изучим реализацию исходящего соединения, а именно:
* Простой HTTP вызов без Egress Gateway
* Simple TLS вызов через Egress Gateway
* Mutual TLS вызов через Egress Gateway