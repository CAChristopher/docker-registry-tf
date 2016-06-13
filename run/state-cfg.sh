#!/bin/bash
if [[ $# -eq 1 ]]; then
  if [[ "$1" =~ ^d[0-9]$ ]]; then
    rm -Rf .terraform
    DATACENTER=$1
    terraform remote config \
    -backend=s3 \
    -backend-config="bucket=<bucket>" \
    -backend-config="key=datacenter/${DATACENTER}/docker-registry-tf/terraform.tfstate" \
    -backend-config="region=us-west-2"
  else
    echo please specify valid datacenter <d#>
  fi
else
  echo please specify the datacenter that your are configuring (d#).
fi