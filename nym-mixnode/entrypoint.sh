#!/bin/bash
set -e

nym_options=(
  --id=${NYM_MIXNODE_ID:-mix}
  --host=$NYM_HOST
  --announce-host=$NYM_ANNOUNCE_HOST
)

if [[ -z $NYM_ANNOUNCE_HOST ]]; then
  echo "Please provide a public Ipv4 or IPv6 address by specifying the environment variable NYM_HOST. See https://nymtech.net/docs/run-nym-nodes/mixnodes/#initialize-a-mixnode."
  exit 1
fi

if [[ -z $NYM_LOCATION ]]; then
  nym_options+=(--location=$NYM_LOCATION)
fi

if [[ -z $NYM_ANNOUNCE_HOST ]]; then
  nym_options+=(--announce-host=$NYM_ANNOUNCE_HOST)
fi

if [[ -z $NYM_INCENTIVES_ADDRESS ]]; then
  nym_options+=(--incentives-address=$NYM_INCENTIVES_ADDRESS)
fi

# Set ulimit
sed "s/.*DefaultLimitNOFILE=.*/DefaultLimitNOFILE=65535/g" -i test.conf

/bin/nym-mixnode init ${nym_options[@]}

/bin/nym-mixnode run --id $NYM_MIXNODE_ID