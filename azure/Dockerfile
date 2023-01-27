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

FROM ghcr.io/epam/hub-toolbox-base:base

LABEL org.opencontainers.image.url="https://github.com/epam/hub-toolbox"
LABEL org.opencontainers.image.source="https://github.com/epam/hub-toolbox.git"
LABEL org.opencontainers.image.authors="Antons Kranga <antons_kranga@epam.com>, Viktors Oginskis <viktors_oginskis@epam.com>, Igor Lysak <igor_lysak@epam.com>"
LABEL org.opencontainers.image.description="Azure Toolbox is a Docker image that is used to perform provisioning operations on a Hub CTL stack, such as deploy and undeploy in Microsoft Azure."
LABEL org.opencontainers.image.licenses="Apache-2.0"

RUN \
    apk update && apk --no-cache --prune upgrade && \
    apk --no-cache add \
        build-base \
        openssl-dev \
        libffi-dev \
        python3-dev \
        py3-pip

RUN rm -rf /var/cache/apk/* /tmp/*

RUN pip3 install azure-cli
