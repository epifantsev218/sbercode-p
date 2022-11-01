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

os_dir=/usr/local/pg
task_dir=/root

pg_pass=$(cat /proc/sys/kernel/random/uuid)
pg_id=$(cat /proc/sys/kernel/random/uuid)
oc create secret generic pg-postgresql --from-literal=postgres-password="$pg_pass" --dry-run=client -oyaml | oc apply -f-
oc apply -f ${os_dir}/postgresql.yml -n "${curr_project}"
pg_ip=$(oc get service pg -o template --template {{.spec.clusterIP}})
sed "s/PG_IP/${pg_ip}/g; s/PG_ID/${pg_id}/g" ${os_dir}/connection.env >> ${task_dir}/connection.env
sed "s/PG_ID/${pg_id}/g" ${os_dir}/postgresql-client.yml >> ${task_dir}/postgresql-client.yml

oc config use-context ${work_context}
