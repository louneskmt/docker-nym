#!/bin/bash
set -e

variablesList=(
  NYM_ID
  NYM_HOST
  NYM_ANNOUNCE_HOST
  NYM_ANNOUNCE_PORT
  NYM_INCENTIVES_ADDRESS
  NYM_LOCATION
  NYM_LAYER
  NYM_METRICS_SERVER
  NYM_VALIDATOR
)

nym_options=()

for variable in ${variablesList[@]}
do
  param="$(echo --$variable= | sed 's/NYM_//g' | sed 's/_/-/g' | awk '{ print tolower($0) }')"
  if [[ ! -z ${!variable} ]]; then
    nym_options+=($param${!variable})
  fi
done

# Set ulimit
sed "s/.*DefaultLimitNOFILE=.*/DefaultLimitNOFILE=65535/g" -i /etc/systemd/system.conf

/bin/nym-mixnode init ${nym_options[@]} $@
/bin/nym-mixnode run --id $NYM_ID