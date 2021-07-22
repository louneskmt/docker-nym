ARG VERSION=v0.11.0
ARG BUILDER_DIR=/srv/nym

FROM rust:1.53.0-slim-buster as builder

ARG SRC_DIR=/usr/local/src/nym
ARG BUILDER_DIR
ARG VERSION

RUN apt-get update -y \
&& apt-get install -y pkg-config build-essential libssl-dev curl jq git

RUN rustup update

WORKDIR $SRC_DIR

RUN git clone https://github.com/nymtech/nym.git $SRC_DIR \
 && git checkout tags/$VERSION

RUN cargo build --release --target-dir $BUILDER_DIR