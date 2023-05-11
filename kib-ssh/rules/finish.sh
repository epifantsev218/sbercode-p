#!/bin/bash
PS1=1
source /root/.bashrc

function url {
    grep "$1" "/root/$2-params.env" | cut -d'=' -f2
}

ssh localhost -f 'echo test' > 1.txt
COUNT=$(cat 1.txt | grep test | wc -l)

jq --null-input \
--arg COUNT "$COUNT" \
'{
    "count": $COUNT,
}'