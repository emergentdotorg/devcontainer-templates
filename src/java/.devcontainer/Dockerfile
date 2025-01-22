# syntax=docker/dockerfile:1.4

ARG VARIANT

FROM mcr.microsoft.com/devcontainers/java:${VARIANT}

ARG _REMOTE_USER

RUN set -eu \
    # Upgrade OS
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y upgrade --no-install-recommends \
    # Install common admin command line tools
    && apt-get install -y --no-install-recommends \
        # Common tools
        fontconfig \
        # Networking tools
        dnsutils \
        iputils-arping \
        iputils-ping \
        netcat-openbsd \
        openssh-client \
        # Terminal tools
        screen \
        tmux \
    # Generate Font Cache
    && fc-cache -f -v \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN set -eu \
    && echo "_REMOTE_USER=${_REMOTE_USER}" \
    && mkdir -p /home/${_REMOTE_USER}/bin
COPY bin/* /home/${_REMOTE_USER}/bin/
RUN set -eu \
    && chown -R ${_REMOTE_USER}:${_REMOTE_USER} /home/${_REMOTE_USER}/bin \
    && chmod +x /home/${_REMOTE_USER}/bin/*
