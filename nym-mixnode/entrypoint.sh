#!/bin/bash
set -e

variablesList=(
  NYM_ID
  NYM_HOST
  NYM_PORT
  NYM_ANNOUNCE_HOST
  NYM_ANNOUNCE_PORT
  NYM_LAYER
  NYM_METRICS_SERVER
  NYM_MIXNET_CONTRACT
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

if [[ -z $NYM_ID ]]; then
  echo "Please provide an ID for your mixnode (NYM_ID environment variable)."
  exit 1
fi

if [[ -z $NYM_TELEGRAM_USER ]]; then
  echo "Please provide a Telegram username for your mixnode (NYM_TELEGRAM_USER environment variable)."
  echo "See https://nymtech.net/docs/run-nym-nodes/mixnodes/#claim-your-mixnode-in-telegram-so-you-can-get-tokens"
  echo "Example: 'NYM_TELEGRAM_USER: @nym'"
  exit 1
fi

NYM_DATA_DIR="/data/.nym"

if [ ! -e $NYM_DATA_DIR/.initiated ]; then
  echo "Running: /usr/local/bin/nym-mixnode init ${nym_options[@]} $@"
  /usr/local/bin/nym-mixnode init ${nym_options[@]} $@
  echo
  echo "Running: /usr/local/bin/nym-mixnode sign --id $NYM_ID --text $NYM_TELEGRAM_USER"
  /usr/local/bin/nym-mixnode sign --id $NYM_ID --text $NYM_TELEGRAM_USER

  touch $NYM_DATA_DIR/.initiated
fi

echo
echo "Trying to upgrade..."
echo "Running: /usr/local/bin/nym-mixnode upgrade --id $NYM_ID"
/usr/local/bin/nym-mixnode upgrade --id $NYM_ID

echo
echo "Starting mixnode..."
echo "Running: /usr/local/bin/nym-mixnode run --id $NYM_ID"
/usr/local/bin/nym-mixnode run --id $NYM_ID