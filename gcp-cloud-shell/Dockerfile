# Copyright 2023 EPAM Systems, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Checkout Hub CLI Extensions
FROM alpine/git:v2.36.3 as hub-extensions

ARG HUB_EXTENSIONS_VERSION="stable"

WORKDIR /tmp
RUN git clone https://github.com/epam/hub-extensions.git && \
    cd hub-extensions && \
    git checkout ${HUB_EXTENSIONS_VERSION}

# Checkout kubectx & kubens
FROM alpine/git:v2.36.3 as kube-tools

WORKDIR /tmp
RUN git clone https://github.com/ahmetb/kubectx && \
    cd kubectx

# Installing Tools
FROM alpine:3.17 as blobs

RUN apk update && \
    apk add zip gzip unzip tar curl git

WORKDIR /usr/local/bin/

### Install yq
ARG YQ_VERSION="4.30.8"
RUN FILE="yq" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" && \
    chmod +x "${FILE}" && "${FILE}" -V

WORKDIR /opt/tar

### Install k6
ARG K6_VERSION="0.42.0"
RUN FILE="k6-v${K6_VERSION}-linux-amd64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/grafana/k6/releases/download/v${K6_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ --strip-components=1

### Install k6x
ARG XK6_VERSION="0.8.1"
RUN FILE="xk6_${XK6_VERSION}_linux_amd64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/grafana/xk6/releases/download/v${XK6_VERSION}/${FILE}" && \
    tar xf "${FILE}" -C /usr/local/bin/ xk6

### Install Hub CLI
ARG HUB_CTL_RELEASE_VERSION="1.0.10"
RUN FILE="hub_Linux_x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/epam/hubctl/releases/download/v${HUB_CTL_RELEASE_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ hub

### Install Hub state extension
ARG HUB_STATE_RELEASE_VERSION="1.0.0"
RUN FILE="hub-state_Linux_x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/epam/hub-state/releases/download/v${HUB_STATE_RELEASE_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ hub-state

# GCP Cloud Shell
FROM gcr.io/cloudshell-images/cloudshell:latest

LABEL org.opencontainers.image.url="https://github.com/epam/hub-toolbox"
LABEL org.opencontainers.image.source="https://github.com/epam/hub-toolbox.git"
LABEL org.opencontainers.image.authors="Antons Kranga <antons_kranga@epam.com>, Viktors Oginskis <viktors_oginskis@epam.com>, Igor Lysak <igor_lysak@epam.com>"
LABEL org.opencontainers.image.description="GCP Cloud Shell is a Docker image that is used to perform provisioning operations on a Hub CTL stack, such as deploy and undeploy in Google Cloud Provider as Cloud Sheel custom image."
LABEL org.opencontainers.image.licenses="Apache-2.0"

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
