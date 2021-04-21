#!/bin/bash
set -e

variablesList=(
  NYM_ID
  NYM_CLIENTS_ANNOUNCE_HOST
  NYM_CLIENTS_ANNOUNCE_PORT
  NYM_CLIENTS_HOST
  NYM_CLIENTS_PORT
  NYM_CLIENTS_LEDGER
  NYM_MIX_ANNOUNCE_HOST
  NYM_MIX_ANNOUNCE_PORT
  NYM_MIX_HOST
  NYM_MIX_PORT
  NYM_INBOXES
  NYM_VALIDATOR
)

nym_options=()

for variable in ${variablesList[@]}
do
  param="$(echo --$variable= | sed 's/NYM_//g' | sed 's/_/-/g' | awk '{ print tolower($0) }')"
  if [[ ! -z ${!variable} ]]; then
    nym_options+=($param${!variable})
  fi
fi

if [[ -z $NYM_ID ]]; then
  echo "Please provide an ID for your gateway (NYM_ID environment variable)."
  exit 1
fi

NYM_DATA_DIR="/data/.nym"

if [ ! -e $NYM_DATA_DIR/.initiated ]; then
  echo "Running: /usr/local/bin/nym-gateway init ${nym_options[@]} $@"
  /usr/local/bin/nym-gateway init ${nym_options[@]} $@
  
  touch $NYM_DATA_DIR/.initiated
fi

/usr/local/bin/nym-gateway run --id $NYM_ID