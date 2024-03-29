#!/bin/bash -x
PS1=1
source /root/.bashrc

_user=student
work_project=work

work_context=${work_project}-${_user}

curr_project=$(oc project -q)

template_dir=/usr/local/template
os_dir=/usr/local/os
task_dir=/root

oc config use-context ${work_context}

# server
oc apply -f "${os_dir}/server.yml"
# ingress
sed "s/PROJECT_PLACEHOLDER/${curr_project}/g" "${template_dir}/ingress-params.env" >> "${os_dir}/ingress-params.env"
oc process -f "${os_dir}/ingress-template.yml" --param-file "${os_dir}/ingress-params.env" -o yaml > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"
#egress
sed "s/PROJECT_PLACEHOLDER/${curr_project}/g" "${template_dir}/egress-params.env" >> "${os_dir}/egress-params.env"
oc process -f "${template_dir}/egress-template.yml" --param-file "${os_dir}/egress-params.env" -o yaml > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"
# cert
mutual_url="$(cat /proc/sys/kernel/random/uuid).apps.sbc-okd.pcbltools.ru"
mkdir "${task_dir}/server"
sed "s/MUTUAL_URL_PLACEHOLDER/${mutual_url}/g" "${template_dir}/server.cnf" >> "${task_dir}/server/server.cnf"
# mutual TLS
sed "s/MUTUAL_URL_PLACEHOLDER/${mutual_url}/g" "${template_dir}/mutual-server-params.env" >> "${os_dir}/mutual-server-params.env"
oc process -f "${template_dir}/mutual-server.yml" --param-file "${os_dir}/mutual-server-params.env" -o yaml > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"
sed "s/MUTUAL_URL_PLACEHOLDER/${mutual_url}/g" "${template_dir}/mutual-params.env" > "${os_dir}/mutual-params.env"
oc process -f "${template_dir}/mutual.yml" --param-file "${os_dir}/mutual-params.env" -o yaml > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"
#client
sed "s/MUTUAL_ADDRESS_PLACEHOLDER/${mutual_url}/g" "${template_dir}/client.yml" > "${os_dir}/conf.yml"
oc apply -f "${os_dir}/conf.yml"

cd "${task_dir}"
