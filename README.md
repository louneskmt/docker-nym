# Docker Nym

This repository provides Docker images for Nym. Images are built on tag using a GitHub Workflow (see its [source code](https://github.com/louneskmt/docker-nym/blob/main/.github/workflows/on-tag.yml) and [runs](https://github.com/louneskmt/docker-nym/actions).

All images are uploaded automatically to my Docker Hub account:
- [Nym Mixnode image](https://hub.docker.com/repository/docker/louneskmt/nym-mixnode)
- [Nym Mixnode image](https://hub.docker.com/repository/docker/louneskmt/nym-gateway)

More info about Nym:
- [Official website](https://nymtech.net)
- [Documentation](https://nymtech.net/docs/overview/)

---
## Nym Mixnode
On first startup, the mixnode will be automatically initiated with your configuration.

You'll need to follow [these instructions](https://nymtech.net/docs/run-nym-nodes/mixnodes/#claim-your-mixnode-in-telegram-so-you-can-get-tokens) to claim your node. 

The details you will need are available in the container logs:
```
$ docker-compose logs
OR
$ docker logs nym-mixnode
```

### Configuration options
All your Nym mixnode configuration can be set using the following environment variables.

You can find more info on these on the [official documentation page](https://nymtech.net/docs/run-nym-nodes/mixnodes/).
| Name                | Description |
| ---                 | --- |
| `NYM_ID`              | Id of the nym-mixnode we want to run |
| `NYM_HOST`            | The custom host on which the mixnode will be running |
| `NYM_PORT`            | The port on which the mixnode will be listening |
| `NYM_ANNOUNCE_HOST`   | The host that will be reported to the directory server |
| `NYM_ANNOUNCE_PORT`   | The port that will be reported to the directory server |
| `NYM_LAYER`          | The mixnet layer of this particular node |
| `NYM_METRICS_SERVER`  | Server to which the node is sending all metrics data |
| `NYM_MIXNET_CONTRACT` | Address of the validator contract managing the network |
| `NYM_VALIDATOR`       | REST endpoint of the validator the node is registering presence with |

### Example

You can either run this container as a standlone container, or using [`docker-compose`](https://docs.docker.com/compose/install/).


#### Compose file example (prefered method):
```yml
version: '3.7'

services:
  mixnode:
    image: louneskmt/nym-mixnode:v0.10.0
    container_name: nym-mixnode
    ulimits:
      nproc: 65535
    ports:
      - "1789:1789"
    volumes:
      - $PWD/data:/data
    environment:
      NYM_ID: "mixnode"
      NYM_HOST: "172.20.0.3"
      NYM_PORT: "1789"
      NYM_ANNOUNCE_HOST: "X:X:X:X"
      NYM_ANNOUNCE_PORT: "1789"
      NYM_TELEGRAM_USER: "@username"
    networks:
      nym:
        ipv4_address: 172.20.0.3

networks:
  nym:
    name: nym_network
    ipam:
      driver: default
      config:
        - subnet: "172.20.0.0/16"
```

#### As a standlone container (not well tested):
```shell
$ docker network create --subnet=172.20.0.0/16 nym_network
$ docker run -d \
         -v $PWD/data:/data \
         -p "1789:1789" \
         -e 'NYM_ID=mixnode' \
         -e 'NYM_HOST=172.20.0.3' \
         -e 'NYM_PORT=1789' \
         -e 'NYM_ANNOUNCE_HOST=213.136.91.13' \
         -e 'NYM_ANNOUNCE_PORT=1789' \
         -e 'NYM_TELEGRAM_USER="@username"' \
         --ulimit "nproc=65535" \
         --network "nym_network" \
         --ip "172.20.0.3" \
         --name "nym-mixnode" \
         louneskmt/nym-mixnode:v0.10.0
```

## Nym Gateway
On first startup, the gateway will be automatically initiated with your configuration.

Some details are available in the container logs:
```
$ docker-compose logs
OR
$ docker logs nym-gateway
```

### Configuration options
All your Nym gateway configuration can be set using the following environment variables.

You can find more info on these on the [official documentation page](https://nymtech.net/docs/run-nym-nodes/gateways/).
| Name                        | Description |
| ---                         | --- |
| `NYM_ID`                    | Id of the gateway we want to create config for |
| `NYM_CLIENTS_ANNOUNCE_HOST` | The port that will be reported to the directory server |
| `NYM_CLIENTS_ANNOUNCE_PORT` | The host that will be reported to the directory server |
| `NYM_CLIENTS_HOST`          | The custom host on which the gateway will be running for receiving clients gateway-requests |
| `NYM_CLIENTS_PORT`          | The port on which the gateway will be listening for clients gateway-requests |
| `NYM_CLIENTS_LEDGER`        | Ledger directory containing registered clients |
| `NYM_MIX_ANNOUNCE_HOST`     | The host that will be reported to the directory server |
| `NYM_MIX_ANNOUNCE_PORT`     | The port that will be reported to the directory server |
| `NYM_MIX_HOST`              | The custom host on which the gateway will be running for receiving sphinx packets |
| `NYM_MIX_PORT`              | The port on which the gateway will be listening for sphinx packets |
| `NYM_INBOXES`               | Directory with inboxes where all packets for the clients are stored |
| `NYM_VALIDATOR`             | REST endpoint of the validator the node is registering presence with |
| `NYM_MIXNET_CONTRACT` | Address of the validator contract managing the network |
