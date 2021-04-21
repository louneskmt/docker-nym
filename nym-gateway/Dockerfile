ARG VERSION=v0.10.0
ARG BUILDER_DIR=/srv/nym/release

FROM louneskmt/nym-builder:$VERSION as builder

FROM debian:buster-slim as final 

ARG BUILDER_DIR
ARG USER=nym
ARG BIN_DIR=/usr/local/bin
ARG DATA_DIR=/data

RUN apt-get update -y \
&& apt-get install -y libssl-dev curl jq git

RUN adduser --home "$DATA_DIR" --shell /bin/bash --disabled-login --gecos "$USER user" $USER

COPY --from=builder --chown=$USER:$USER $BUILDER_DIR/nym-gateway $BIN_DIR/nym-gateway

COPY    ./entrypoint.sh /entrypoint.sh

RUN     chown $USER:$USER /entrypoint.sh && \
        chmod u+x /entrypoint.sh && \
        chmod g+x /entrypoint.sh

USER $USER

ENTRYPOINT [ "/entrypoint.sh" ]