#!/bin/bash
mkdir certs

vault read -field=key secret/blah/cert > ./certs/key.pem
vault read -field=cert secret/blah/cert > ./certs/cert.crt
vault read -field=ca secret/blah/cert > ./certs/DigiCertCA.crt
