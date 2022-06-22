# Checkout Hub CLI Extensions
FROM alpine/git:latest as hub-extensions

ARG HUB_EXTENSIONS_VERSION="master"

WORKDIR /tmp
RUN git clone https://github.com/agilestacks/hub-extensions.git && \
    cd hub-extensions && \
    git checkout ${HUB_EXTENSIONS_VERSION}

# Checkout kubectx & kubens
FROM alpine/git:latest as kube-tools

WORKDIR /tmp
RUN git clone https://github.com/ahmetb/kubectx && \
    cd kubectx

# Installing Tools
FROM alpine:3.15 as blobs

ARG YQ_VERSION="4.16.2"
ARG JQ_VERSION="1.6"
ARG K6_VERSION="0.37.0"
ARG XK6_VERSION="0.6.1"
ARG HELM3_VERSION="3.8.2"
ARG HUB_CLI_RELEASE_VERSION="1.0.9"
ARG HUB_STATE_RELEASE_VERSION="1.0.0"

RUN apk update && \
    apk add zip gzip unzip tar curl git

WORKDIR /usr/local/bin/

### Install yq
RUN FILE="yq" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" && \
    chmod +x "${FILE}" && "${FILE}" -V

### Install jq
RUN FILE="jq" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" && \
    chmod +x "${FILE}" && "${FILE}" -V

WORKDIR /opt/tar

### Install k6
RUN FILE="k6-v${K6_VERSION}-linux-amd64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/grafana/k6/releases/download/v${K6_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ --strip-components=1

### Install k6x
RUN FILE="xk6_${XK6_VERSION}_linux_amd64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/grafana/xk6/releases/download/v${XK6_VERSION}/${FILE}" && \
    tar xf "${FILE}" -C /usr/local/bin/ xk6

### Install helm
RUN FILE="helm-v${HELM3_VERSION}-linux-amd64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://get.helm.sh/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ --strip-components=1 linux-amd64/helm

### Install Hub CLI
RUN FILE="hub_Linux_x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/agilestacks/hub/releases/download/v${HUB_CLI_RELEASE_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ hub

### Install Hub state extension
RUN FILE="hub-state_Linux_x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/agilestacks/hub-state/releases/download/v${HUB_STATE_RELEASE_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ hub-state

# GCP Cloud Shell
FROM gcr.io/cloudshell-images/cloudshell:latest

### Install missing packages
RUN apt-get update && \
    apt-get install uuid-runtime netcat -y

### Install extensions
COPY --from=hub-extensions /tmp/hub-extensions /usr/local/share/hub
### Install kubectx & kubens
COPY --from=kube-tools /tmp/kubectx/kubectx /usr/local/bin
COPY --from=kube-tools /tmp/kubectx/kubens /usr/local/bin
### Install tools
COPY --from=blobs /usr/local/bin /usr/local/bin

COPY bashrc.google /google/devshell/bashrc.google
