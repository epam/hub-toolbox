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

# Installing tools
FROM alpine:3.17 as blobs
RUN apk update && \
    apk add zip gzip unzip tar curl git

WORKDIR /usr/local/bin/

### Install Google Cloud CLI
ARG GOOGLE_CLOUD_CLI_VERSION="422.0.0"
RUN FILE="google-cloud-cli-${GOOGLE_CLOUD_CLI_VERSION}-linux-x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/

# GCP Toolbox
FROM ghcr.io/epam/hub-toolbox:base

LABEL org.opencontainers.image.url="https://github.com/epam/hub-toolbox"
LABEL org.opencontainers.image.source="https://github.com/epam/hub-toolbox.git"
LABEL org.opencontainers.image.authors="Antons Kranga <antons_kranga@epam.com>, Viktors Oginskis <viktors_oginskis@epam.com>, Igor Lysak <igor_lysak@epam.com>"
LABEL org.opencontainers.image.description="GCP Toolbox is a Docker image that is used to perform provisioning operations on a Hub CTL stack, such as deploy and undeploy in Google Cloud Provider."
LABEL org.opencontainers.image.licenses="Apache-2.0"

ENV PATH /usr/local/google-cloud-sdk/bin:${PATH}

ENV USE_GKE_GCLOUD_AUTH_PLUGIN "True"

RUN \
    apk update && apk --no-cache --prune upgrade && \
    apk --no-cache add \
        python3

COPY --from=blobs /usr/local/google-cloud-sdk /usr/local/google-cloud-sdk

RUN rm -rf /var/cache/apk/* /tmp/*

RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true

RUN gcloud components install beta --quiet && \
    gcloud components install gke-gcloud-auth-plugin --quiet && \
    rm -rf /usr/local/google-cloud-sdk/.install/.backup && \
    find /usr/local/google-cloud-sdk/ -type d -iname "__pycache__" -exec rm -rf {} + -prune && \
    gcloud --version
