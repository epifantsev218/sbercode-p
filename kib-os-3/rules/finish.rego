package sbercode

allow[msg] {
	res := input.se
    res.easy != "0"
	msg := "[OK] создан Service Entry для HTTP-соединения"
}

deny[msg] {
	res := input.se
    res.easy == "0"
	msg := "[ERROR] не создан Service Entry для HTTP-соединения"
}

allow[msg] {
	res := input.se
    res.simple != "0"
	msg := "[OK] создан Service Entry для Simple TLS"
}

deny[msg] {
	res := input.se
    res.simple == "0"
	msg := "[ERROR] не создан Service Entry для Simple TLS"
}

allow[msg] {
	res := input.se
    res.mutual != "0"
	msg := "[OK] создан Service Entry для Mutual TLS"
}

deny[msg] {
	res := input.se
    res.mutual == "0"
	msg := "[ERROR] не создан Service Entry для Mutual TLS"
}

allow[msg] {
	res := input.gw
    res.simple != "0"
	msg := "[OK] создан Gateway для Simple TLS"
}

deny[msg] {
	res := input.gw
    res.simple == "0"
	msg := "[ERROR] не создан Gateway для Simple TLS"
}

allow[msg] {
	res := input.gw
    res.mutual != "0"
	msg := "[OK] создан Gateway для Mutual TLS"
}

deny[msg] {
	res := input.gw
    res.mutual == "0"
	msg := "[ERROR] не создан Gateway для Mutual TLS"
}

allow[msg] {
	res := input.vs
    res.simple != "0"
	msg := "[OK] создан Virtual Service для Simple TLS"
}

deny[msg] {
	res := input.vs
    res.mutual == "0"
	msg := "[ERROR] не создан Virtual Service для Mutual TLS"
}

allow[msg] {
	res := input.gw
    res.mutual != "0"
	msg := "[OK] создан Virtual Service для Mutual TLS"
}

deny[msg] {
	res := input.vs
    res.simple == "0"
	msg := "[ERROR] не создан Virtual Service для Simple TLS"
}

allow[msg] {
	res := input.dr
    res.simple != "0"
	msg := "[OK] создан Destination Rule для Simple TLS"
}

deny[msg] {
	res := input.dr
    res.simple == "0"
	msg := "[ERROR] не создан Destination Rule для Simple TLS"
}

allow[msg] {
	res := input.dr
    res.mutual != "0"
	msg := "[OK] создан Destination Rule для Mutual TLS"
}

deny[msg] {
	res := input.dr
    res.mutual == "0"
	msg := "[ERROR] не создан Destination Rule для Mutual TLS"
}

allow[msg] {
	res := input.curl
	startswith(res.easy, "200:")
	msg := "[OK] успешная проверка HTTP-соединения"
}

deny[msg] {
	res := input.curl
	not startswith(res.easy, "200:")
	msg := concat(" ", ["[ERROR] ошибка при проверке HTTP соединения. Код ошибки",res.easy])
}

allow[msg] {
	res := input.curl
	startswith(res.simple, "200:")
	msg := "[OK] успешная проверка Simple TLS"
}

deny[msg] {
	res := input.curl
	not startswith(res.simple, "200:")
	msg := concat(" ", ["[ERROR] ошибка при проверке Simple TLS. Код ошибки",res.simple])
}

allow[msg] {
	res := input.curl
	startswith(res.mutual, "200:")
	msg := "[OK] успешная проверка Mutual TLS"
}

deny[msg] {
	res := input.curl
	not startswith(res.mutual, "200:")
	msg := concat(" ", ["[ERROR] ошибка при проверке Mutual TLS. Код ошибки",res.mutual])
}

error[msg] {
	msg := input.error
}
