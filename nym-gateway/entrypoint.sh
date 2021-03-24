#!/bin/bash
set -e

nym_options=(
  --id=${NYM_GATEWAY_ID:-mix}
  --host=${NYM_CLIENTS_HOST}
  --mix-host=${NYM_MIX_HOST}
)

if [[ -z $NYM_CLIENTS_HOST ]]; then
  echo "Please provide an IPv4 or IPv6 address that the gateway will listen on for requests coming from Nym clients, by specifying the environment variable NYM_CLIENTS_HOST. See https://nymtech.net/docs/run-nym-nodes/gateways/#initializing-a-gateway."
  exit 1
fi

if [[ -z $NYM_MIX_HOST ]]; then
  echo "Please provide an IPv4 or IPv6 address that the gateway will listen on for incoming Sphinx packets coming from the mixnet by specifying the environment variable NYM_MIX_HOST. See https://nymtech.net/docs/run-nym-nodes/gateways/#initializing-a-gateway."
  exit 1
fi

/bin/nym-gateway init ${nym_options[@]}
/bin/nym-gateway run --id $NYM_GATEWAY_ID