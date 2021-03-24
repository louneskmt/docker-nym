ARG VERSION=v0.9.2
ARG BUILDER_DIR=/srv/nym

FROM rust:1.50.0-slim-buster as builder

ARG SRC_DIR=/usr/local/src/nym
ARG BUILDER_DIR
ARG VERSION

RUN apt-get update -y \
&& apt-get install -y pkg-config build-essential libssl-dev curl jq git

RUN git clone --branch $VERSION https://github.com/nymtech/nym.git $SRC_DIR

WORKDIR $SRC_DIR

RUN cargo build --release --target-dir $BUILDER_DIR

FROM debian:buster-slim as final 

ARG BUILDER_DIR
ARG USER=nym
ARG BIN_DIR=/usr/local/bin
ARG DATA_DIR=/data

COPY --from=builder --chown=$USER:$USER $BUILDER_DIR/* $BIN_DIR

RUN adduser --home "$DATA_DIR" --shell /bin/bash --disabled-login --gecos "$USER user" $USER

USER $USER