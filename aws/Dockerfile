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

FROM python:3.11-alpine3.18 as builder

# Install deps
RUN apk update && apk --no-cache --prune upgrade \
    && apk --no-cache add \
        git=2.40.1-r0 \
        unzip=6.0-r14 \
        groff=1.22.4-r4 \
        build-base=0.5-r3 \
        libffi-dev=3.4.4-r2 \
        cmake=3.26.5-r0 \
        sqlite-dev=3.41.2-r2
RUN rm -rf /var/cache/apk/* /tmp/*

WORKDIR /opt/src

# Install AWS CLI
ARG AWS_CLI_VERSION="2.13.14"
RUN git clone --single-branch --depth 1 -b "${AWS_CLI_VERSION}" https://github.com/aws/aws-cli.git
WORKDIR /opt/src/aws-cli
RUN ./configure --with-install-type=portable-exe --with-download-deps
RUN make
RUN make install

# Clean up
RUN rm -rf \
    /usr/local/lib/aws-cli/aws_completer \
    /usr/local/lib/aws-cli/awscli/data/ac.index \
    /usr/local/lib/aws-cli/awscli/examples
RUN find /usr/local/lib/aws-cli/awscli/data -name completions-1*.json -delete
RUN find /usr/local/lib/aws-cli/awscli/botocore/data -name examples-1.json -delete
RUN (cd /usr/local/lib/aws-cli; for a in *.so*; do test -f /lib/$a && rm $a; done)

# AWS toolbox
FROM ghcr.io/epam/hub-toolbox:base

LABEL org.opencontainers.image.url="https://github.com/epam/hub-toolbox"
LABEL org.opencontainers.image.source="https://github.com/epam/hub-toolbox.git"
LABEL org.opencontainers.image.authors="Antons Kranga <antons_kranga@epam.com>, Viktors Oginskis <viktors_oginskis@epam.com>, Igor Lysak <igor_lysak@epam.com>"
LABEL org.opencontainers.image.description="AWS Toolbox is a Docker image that is used to perform provisioning operations on a Hub CTL stack, such as deploy and undeploy in Amazon Web Services."
LABEL org.opencontainers.image.licenses="Apache-2.0"

COPY --from=builder /usr/local/lib/aws-cli/ /usr/local/lib/aws-cli/

RUN ln -s /usr/local/lib/aws-cli/aws /usr/local/bin/aws
