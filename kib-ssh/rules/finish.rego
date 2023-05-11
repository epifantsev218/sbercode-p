package sbercode

allow[msg] {
	res := input
    res.count == 1
	msg := "[OK] успешное подключение по SSH"
}

deny[msg] {
	res := input
    res.count != 1
	msg := "[ERROR] подключиться по SSH не удалось"
}

error[msg] {
	msg := input.error
}
