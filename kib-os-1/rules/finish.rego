package sbercode

allow[msg] {
	res := input
    res.egress == "1"
	msg := "[OK] создан под Egress Gateway"
}

deny[msg] {
	res := input
    res.egress != "1"
	msg := "[ERROR] не создан под Egress Gateway"
}

allow[msg] {
	res := input.log
    res.sidecar != "0"
	msg := "[OK] успешный вызов через sidecar proxy"
}

deny[msg] {
	res := input.log
    res.sidecar == "0"
	msg := "[ERROR] отсутствует вызов через sidecar proxy"
}

allow[msg] {
	res := input.log
    res.egress != "0"
	msg := "[OK] успешный вызов через Egress Gateway"
}

deny[msg] {
	res := input.log
    res.egress == "0"
	msg := "[ERROR] отсутствует вызов через Egress Gateway"
}

allow[msg] {
	res := input
    res.gw == "1"
	msg := "[OK] создан Gateway для узла Kafka"
}

deny[msg] {
	res := input
    res.gw != "1"
	msg := "[ERROR] не создан Gateway узла Kafka"
}

allow[msg] {
	res := input
    res.vs == "2"
	msg := "[OK] создан Virtual Service для узла Kafka"
}

deny[msg] {
	res := input
    res.vs != "2"
	msg := "[ERROR] не создан Virtual Service узла Kafka"
}

allow[msg] {
	res := input
    res.se == "1"
	msg := "[OK] создан Service Entry для узла Kafka"
}

deny[msg] {
	res := input
    res.se != "1"
	msg := "[ERROR] не создан Service Entry узла Kafka"
}

error[msg] {
	msg := input.error
}
