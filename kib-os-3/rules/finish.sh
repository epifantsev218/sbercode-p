#!/bin/bash
PS1=1
source /root/.bashrc

function url {
    grep "$1" "/root/$2-params.env" | cut -d'=' -f2
}

# Проверка наличия URL для вызова
EASY_URL=$(url 'HOST' 'easy')
SIMPLE_URL=$(url 'HOST' 'simple')
MUTUAL_URL=$(url 'HOST' 'mutual')
# Проверка HTTP вызова
EASY_RESULT="$(oc exec $(oc get pods -o name | grep client | head -n 1) -- sh -c 'curl -o /dev/null -w "%{http_code}: %{errormsg}\n" http://$EASY_ADDRESS' 2>/dev/null)"
SIMPLE_RESULT="$(oc exec $(oc get pods -o name | grep client | head -n 1) -- sh -c 'curl -o /dev/null -w "%{http_code}: %{errormsg}\n" http://$SIMPLE_ADDRESS' 2>/dev/null)"
MUTUAL_RESULT="$(oc exec $(oc get pods -o name | grep client | head -n 1) -- sh -c 'curl -o /dev/null -w "%{http_code}: %{errormsg}\n" http://$MUTUAL_ADDRESS' 2>/dev/null)"
# Проверка конфигов Openshift
SIMPLE_GW=$(oc describe gateways 2>&1 | grep ${SIMPLE_URL} | wc -l)
MUTUAL_GW=$(oc describe gateways 2>&1 | grep ${MUTUAL_URL} | wc -l)
SIMPLE_VS=$(oc describe virtualservices 2>&1 | grep ${SIMPLE_URL} | wc -l)
MUTUAL_VS=$(oc describe virtualservices 2>&1 | grep ${MUTUAL_URL} | wc -l)
SIMPLE_DR=$(oc describe destinationrules 2>&1 | grep ${SIMPLE_URL} | wc -l)
MUTUAL_DR=$(oc describe destinationrules 2>&1 | grep ${MUTUAL_URL} | wc -l)
EASY_SE=$(oc describe serviceentries 2>&1 | grep ${SIMPLE_URL} | wc -l)
SIMPLE_SE=$(oc describe serviceentries 2>&1 | grep ${SIMPLE_URL} | wc -l)
MUTUAL_SE=$(oc describe serviceentries 2>&1 | grep ${MUTUAL_URL} | wc -l)

jq --null-input \
--arg EASY_RESULT "$EASY_RESULT" \
--arg SIMPLE_RESULT "$SIMPLE_RESULT" \
--arg MUTUAL_RESULT "$MUTUAL_RESULT" \
--arg EASY_ROUTE "$EASY_ROUTE" \
--arg SIMPLE_ROUTE "$SIMPLE_ROUTE" \
--arg MUTUAL_ROUTE "$MUTUAL_ROUTE" \
--arg SIMPLE_VS "$SIMPLE_VS" \
--arg MUTUAL_VS "$MUTUAL_VS" \
--arg SIMPLE_GW "$SIMPLE_GW" \
--arg MUTUAL_GW "$MUTUAL_GW" \
--arg SIMPLE_DR "$SIMPLE_DR" \
--arg MUTUAL_DR "$MUTUAL_DR" \
--arg EASY_SE "$EASY_SE" \
--arg SIMPLE_SE "$SIMPLE_SE" \
--arg MUTUAL_SE "$MUTUAL_SE" \
'{
    "curl":{"easy": $EASY_RESULT,"simple": $SIMPLE_RESULT,"mutual": $MUTUAL_RESULT,},
    "se":{"easy": $EASY_SE,"simple": $SIMPLE_SE,"mutual": $MUTUAL_SE,},
    "gw":{"simple": $SIMPLE_GW,"mutual": $MUTUAL_GW,},
    "vs":{"simple": $SIMPLE_VS,"mutual": $MUTUAL_VS,},
    "dr":{"simple": $SIMPLE_DR,"mutual": $MUTUAL_DR,},
}'