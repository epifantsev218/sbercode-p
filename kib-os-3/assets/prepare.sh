#!/bin/bash -x
PS1=1
source /root/.bashrc

_user=student
infra_project=infra
work_project=work

infra_context=${infra_project}-${_user}
work_context=${work_project}-${_user}

oc config use-context ${infra_context}
curr_project=$(oc project -q)

template_dir=/usr/local/template
os_dir=/usr/local/os
task_dir=/root

# server
oc apply -f "${os_dir}/server.yml"
# ingress
sed "s/PROJECT_PLACEHOLDER/${curr_project}/g" "${template_dir}/ingress-params.env" >> "${os_dir}/ingress-params.env"
oc process -f "${os_dir}/ingress-template.yml" --param-file "${os_dir}/ingress-params.env" -o yaml > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"
# http
easy_url="$(cat /proc/sys/kernel/random/uuid).apps.sbc-okd.pcbltools.ru"
sed "s/EASY_URL_PLACEHOLDER/${easy_url}/g" "${template_dir}/easy-server-params.env" >> "${os_dir}/easy-server-params.env"
oc process -f "${os_dir}/easy-server.yml" --param-file "${os_dir}/easy-server-params.env" -o yaml > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"
# cert
simple_url="$(cat /proc/sys/kernel/random/uuid).apps.sbc-okd.pcbltools.ru"
mutual_url="$(cat /proc/sys/kernel/random/uuid).apps.sbc-okd.pcbltools.ru"
sed "s/SIMPLE_URL_PLACEHOLDER/${simple_url}/g; s/MUTUAL_URL_PLACEHOLDER/${mutual_url}/g" "${template_dir}/req.cnf" >> "${os_dir}/req.cnf"
openssl req -new -x509 -newkey rsa:2048 -sha256 -nodes -keyout "${os_dir}/key.pem" -days 365 -out "${os_dir}/crt.pem" -config "${os_dir}/req.cnf"
oc create secret generic certs --from-file=key.pem="${os_dir}/key.pem" --from-file=crt.pem="${os_dir}/crt.pem" --from-file=ca.pem="${os_dir}/crt.pem"
# simple TLS
sed "s/SIMPLE_URL_PLACEHOLDER/${simple_url}/g" "${template_dir}/simple-server-params.env" >> "${os_dir}/simple-server-params.env"
oc process -f "${os_dir}/simple-server.yml" --param-file "${os_dir}/simple-server-params.env" -o yaml > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"
# mutual TLS
sed "s/MUTUAL_URL_PLACEHOLDER/${mutual_url}/g" "${template_dir}/mutual-server-params.env" >> "${os_dir}/mutual-server-params.env"
oc process -f "${os_dir}/mutual-server.yml" --param-file "${os_dir}/mutual-server-params.env" -o yaml > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"
#client
sed "s/EASY_URL_PLACEHOLDER/${easy_url}/g" "${template_dir}/easy-params.env" >> "${task_dir}/easy-params.env"
sed "s/SIMPLE_URL_PLACEHOLDER/${simple_url}/g" "${template_dir}/simple-params.env" >> "${task_dir}/simple-params.env"
sed "s/MUTUAL_URL_PLACEHOLDER/${mutual_url}/g" "${template_dir}/mutual-params.env" >> "${task_dir}/mutual-params.env"
sed "s/EASY_ADDRESS_PLACEHOLDER/${easy_url}/g; s/SIMPLE_ADDRESS_PLACEHOLDER/${simple_url}/g; s/MUTUAL_ADDRESS_PLACEHOLDER/${mutual_url}/g" "${template_dir}/client.yml" >> "${task_dir}/client.yml"

oc config use-context ${work_context}
oc create secret generic certs --from-file=key.pem="${os_dir}/key.pem" --from-file=crt.pem="${os_dir}/crt.pem" --from-file=ca.pem="${os_dir}/crt.pem"
