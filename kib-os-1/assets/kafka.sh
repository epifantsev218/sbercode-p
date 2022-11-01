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

os_dir=/usr/local/kafka
task_dir=/root

broker_id=$(cat /proc/sys/kernel/random/uuid)
sed "s/PROJECT_PLACEHOLDER/${curr_project}/g; s/BROKER_ID/${broker_id}/g" ${os_dir}/kafka.yml |oc apply -f-
kafka_ip=$(oc get service kafka -o template --template {{.spec.clusterIP}})
sed "s/KAFKA_IP/${kafka_ip}/g; s/BROKER_ID/${broker_id}/g" ${os_dir}/connection.env >> ${task_dir}/connection.env
sed "s/BROKER_ID/${broker_id}/g" ${os_dir}/kafka-client.yml >> ${task_dir}/kafka-client.yml

oc config use-context ${work_context}
