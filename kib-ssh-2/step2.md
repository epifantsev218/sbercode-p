`./ca/intermediate/certs/ca-chain.cert.pem`{{open}}

`./client/key.pem`{{open}}

`./client/crt.pem`{{open}}

`oc create secret generic egress-certs --from-file=key.pem="./client/key.pem" --from-file=crt.pem="./client/crt.pem" --from-file=ca.pem="./ca/intermediate/certs/ca-chain.cert.pem"`{{execute}}

`oc rollout latest "ci00000000-test-egress"`{execute}