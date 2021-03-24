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
  NYM_INCENTIVES_ADDRESS
  NYM_LOCATION
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
done

/bin/nym-gateaway init ${nym_options[@]} $@
/bin/nym-gateaway run --id $NYM_ID