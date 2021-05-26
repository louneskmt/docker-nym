# Docker Nym

This repository provides Docker images for Nym. Images are built on tag using a GitHub Workflow (see its [source code](https://github.com/louneskmt/docker-nym/blob/main/.github/workflows/on-tag.yml) and [runs](https://github.com/louneskmt/docker-nym/actions)).

All images are uploaded automatically to my Docker Hub account:
- [Nym Mixnode image](https://hub.docker.com/repository/docker/louneskmt/nym-mixnode)
- [Nym Gateway image](https://hub.docker.com/repository/docker/louneskmt/nym-gateway)

More info about Nym:
- [Official website](https://nymtech.net)
- [Official GitHub repository](https://github.com/nymtech/nym)
- [Documentation](https://nymtech.net/docs/overview/)

This repository and these Nym images are not official nor directly affiliated to the Nym team.

# Nym Mixnode
On first startup, the mixnode will be automatically initiated with your configuration. You'll need to follow [these instructions](https://nymtech.net/docs/run-nym-nodes/mixnodes/#claim-your-mixnode-in-telegram-so-you-can-get-tokens) to claim your node.

You can either run this container using [`docker-compose`](https://docs.docker.com/compose/install/), or as a standlone container.

In both cases, create a directory to contain all your Nym mixnode data:
```shell
$ mkdir -p nym-mixnode/data
$ sudo chmod 777 -R nym-mixnode/data
$ cd nym-mixnode
```

The details you will need to claim and bond your node are available in the container logs:
```shell
$ docker-compose logs
OR
$ docker logs nym-mixnode
```

## Setup IPv6
In order for your node to support IPv6 (which is mandatory if you don't want to loose reputation on the network), you will need to configure Docker. As Docker doesn't support well IPv6, we'll use an IPv6 NAT container. More info [here](https://github.com/robbertkl/docker-ipv6nat).

First, create a new Docker IPv6 subnet:

```shell
$ docker network create --ipv6 --subnet="fdc4:f42f:270c:1a84::/64" nym_ipv6_network
```

Replace `fdc4:f42f:270c:1a84::/64` by another random CID generated on
https://simpledns.plus/private-ipv6.

Then, create the NAT container.

```shell
$ docker pull robbertkl/ipv6nat
$ docker run -d \
         --cap-add=NET_ADMIN \
         --cap-add=NET_RAW \
         --cap-add=SYS_MODULE \
         --cap-drop=ALL \
         --name="IPv6NAT" \
         --network=host \
         --restart=unless-stopped \
         --volume="/lib/modules:/lib/modules:ro" \
         --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
         robbertkl/ipv6nat
```

## Example

### Compose file example (prefered method):
Create a `docker-compose.yml` file under the `nym-mixnode` directory.

```yml
version: '3.7'

services:
  mixnode:
    image: louneskmt/nym-mixnode:v0.10.1
    container_name: nym-mixnode
    stop_signal: SIGINT
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
      nym_ipv6:

networks:
  nym:
    name: nym_network
    ipam:
      driver: default
      config:
        - subnet: "172.20.0.0/16"
  nym_ipv6:
    name: nym_ipv6_network
```

To start your Nym mixnode, go to the `nym-mixnode` directory, where `docker-compose.yml` is located, and execute:

```shell
$ docker-compose up -d
```

### As a standlone container (not well tested):
```shell
$ cd nym-mixnode
$ docker network create --subnet=172.20.0.0/16 nym_network
$ docker create \
         -v $PWD/data:/data \
         -p "1789:1789" \
         -e 'NYM_ID=mixnode' \
         -e 'NYM_HOST=172.20.0.3' \
         -e 'NYM_PORT=1789' \
         -e 'NYM_ANNOUNCE_HOST=213.136.91.13' \
         -e 'NYM_ANNOUNCE_PORT=1789' \
         -e 'NYM_TELEGRAM_USER="@username"' \
         --ulimit "nproc=65535" \
         --stop-signal "SIGINT" \
         --network "nym_network" \
         --ip "172.20.0.3" \
         --name "nym-mixnode" \
         louneskmt/nym-mixnode:v0.10.1
$ docker network connect nym_ipv6_network nym-mixnode
$ docker start nym-mixnode
```

## Configuration options
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

# Nym Gateway - Not tested yet
On first startup, the gateway will be automatically initiated with your configuration.

Some details are available in the container logs:
```
$ docker-compose logs
OR
$ docker logs nym-gateway
```

## Configuration options
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
