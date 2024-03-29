# Copyright 2023 EPAM Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM alpine:3.18 as blobs

RUN apk update && apk --no-cache --prune upgrade \
    && apk add --no-cache \
        zip=3.0-r12 \
        gzip=1.12-r1 \
        unzip=6.0-r14 \
        tar=1.34-r3 \
        curl=8.2.1-r0
RUN rm -rf /var/cache/apk/* /tmp/*

# Tools binaries
WORKDIR /usr/local/bin/

### Instrall kubectl
ARG KUBECTL_VERSION="1.26.8"
RUN FILE="kubectl" \
    && test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

### Install YQ
ARG YQ_VERSION="4.35.1"
RUN FILE="yq" \
    && test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64"

### Install JQ
ARG JQ_VERSION="1.6"
RUN FILE="jq" \
    && test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64"

# Tar base tools
WORKDIR /opt/tar

### Install helm
ARG HELM3_VERSION="3.12.3"
RUN FILE="helm-v${HELM3_VERSION}-linux-amd64.tar.gz" \
    && test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://get.helm.sh/${FILE}" \
    && tar xzf "${FILE}" -C /usr/local/bin/ --strip-components=1 linux-amd64/helm

### Install Hub CLI
ARG HUB_CTL_VERSION="1.0.14"
RUN FILE="hubctl_Linux_x86_64.tar.gz" \
    && test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/epam/hubctl/releases/download/v${HUB_CTL_VERSION}/${FILE}" \
    && tar xzf "${FILE}" -C /usr/local/bin/ hubctl

### Zip based tools
WORKDIR /opt/zip

### Install terraform
ARG TF_VERSION="1.5.6"
RUN FILE="terraform_${TF_VERSION}_linux_amd64.zip" \
    && test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" \
    && unzip "${FILE}" -d /usr/local/bin

### Checkout Hub CLI Extensions
FROM alpine/git:v2.40.1 as hub-extensions
ARG HUB_EXTENSIONS_VERSION="master"
RUN mkdir -p /tmp/hub-extensions
WORKDIR /tmp
RUN git clone https://github.com/epam/hub-extensions.git
WORKDIR /tmp/hub-extensions
RUN git checkout ${HUB_EXTENSIONS_VERSION}

### Toolbox
FROM alpine:3.18

LABEL org.opencontainers.image.url="https://github.com/epam/hub-toolbox"
LABEL org.opencontainers.image.source="https://github.com/epam/hub-toolbox.git"
LABEL org.opencontainers.image.authors="Antons Kranga <antons_kranga@epam.com>, Viktors Oginskis <viktors_oginskis@epam.com>, Igor Lysak <igor_lysak@epam.com>"
LABEL org.opencontainers.image.description="Toolbox is a Docker image that is used to perform provisioning operations on a Hub CTL stack, such as deploy and undeploy."
LABEL org.opencontainers.image.licenses="Apache-2.0"

ENV USER "root"
ENV UID  "0"
ENV GID  "0"

COPY --from=blobs          /usr/local/bin      /usr/local/bin
COPY --from=hub-extensions /tmp/hub-extensions /usr/local/share/hub

RUN chmod +x /usr/local/bin/*

RUN apk update && apk --no-cache --prune upgrade \
    && apk add --no-cache \
        bash=5.2.15-r5 \
        curl=8.2.1-r0 \
        git=2.40.1-r0 \
        gzip=1.12-r1 \
        sed=4.9-r2 \
        tar=1.34-r3 \
        vim=9.0.1568-r0
RUN rm -rf /var/cache/apk/* /tmp/*

RUN mkdir /workspace
WORKDIR /workspace
