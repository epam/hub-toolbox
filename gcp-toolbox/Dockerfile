# Installing tools
FROM alpine:3.15 as blobs
RUN apk update && \
    apk add zip gzip unzip tar curl git

ARG DIRENV_VERSION="2.31.0"
ARG GOSU_VERSION="1.14"
ARG HELM3_VERSION="3.8.2"
ARG KUBECTL_VERSION="1.23.6"
ARG TINI_VERSION="0.19.0"
ARG YQ_VERSION="4.25.1"
ARG JQ_VERSION="1.6"
ARG HUB_CLI_VERSION="1.0.9"
ARG HUB_STATE_VERSION="1.0.0"
ARG GOOGLE_CLOUD_CLI_VERSION="386.0.0"
ARG K6_VERSION="0.37.0"
ARG XK6_VERSION="0.6.1"

ARG TF_VERSION="1.1.9"
ARG TF_PROVIDER_GOOGLE_VERSION="4.20.0"
ARG TF_PROVIDER_LOCAL_VERSION="2.2.2"
ARG TF_PROVIDER_NULL_VERSION="3.1.1"
ARG TF_PROVIDER_TEMPLATE_VERSION="2.2.0"
ARG TF_PROVIDER_TLS_VERSION="3.3.0"
ARG TF_PROVIDER_RANDOM_VERSION="3.1.3"

RUN mkdir -p /opt/tf-plugins \
    /opt/tf-custom-plugins

WORKDIR /usr/local/bin/

### Install direnv
RUN FILE="direnv" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64"

### Install tini
RUN FILE="tini" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64"

### Install gosu
RUN FILE="gosu" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64"

### Instrall kubectl
RUN FILE="kubectl" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

### Install YQ
RUN FILE="yq" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64"

### Install JQ
RUN FILE="jq" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64"

WORKDIR /opt/tar

### Install helm
RUN FILE="helm-v${HELM3_VERSION}-linux-amd64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://get.helm.sh/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ --strip-components=1 linux-amd64/helm

### Install Google Cloud CLI
RUN FILE="google-cloud-cli-${GOOGLE_CLOUD_CLI_VERSION}-linux-x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/

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

### Install Hub CLI
RUN FILE="hub_Linux_x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/agilestacks/hub/releases/download/v${HUB_CLI_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ hub

### Install Hub state extension
RUN FILE="hub-state_Linux_x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/agilestacks/hub-state/releases/download/v${HUB_STATE_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ hub-state

WORKDIR /opt/zip

### Install terraform
RUN FILE="terraform_${TF_VERSION}_linux_amd64.zip" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" && \
    unzip "${FILE}" -d /usr/local/bin

### Install terraform google provider
RUN FILE="terraform-provider-google_${TF_PROVIDER_GOOGLE_VERSION}_linux_amd64.zip" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform-provider-google/${TF_PROVIDER_GOOGLE_VERSION}/${FILE}" && \
    unzip "${FILE}" -d /opt/tf-plugins

### Install terraform local provider
RUN FILE="terraform-provider-local_${TF_PROVIDER_LOCAL_VERSION}_linux_amd64.zip" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform-provider-local/${TF_PROVIDER_LOCAL_VERSION}/${FILE}" && \
    unzip "${FILE}" -d /opt/tf-plugins

### Install terraform null provider
RUN FILE="terraform-provider-null_${TF_PROVIDER_NULL_VERSION}_linux_amd64.zip" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform-provider-null/${TF_PROVIDER_NULL_VERSION}/${FILE}" && \
    unzip "${FILE}" -d /opt/tf-plugins

### Install terraform template provider
RUN FILE="terraform-provider-template_${TF_PROVIDER_TEMPLATE_VERSION}_linux_amd64.zip" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform-provider-template/${TF_PROVIDER_TEMPLATE_VERSION}/${FILE}" && \
    unzip "${FILE}" -d /opt/tf-plugins

### Install terraform tls provider
RUN FILE="terraform-provider-tls_${TF_PROVIDER_TLS_VERSION}_linux_amd64.zip" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform-provider-tls/${TF_PROVIDER_TLS_VERSION}/${FILE}" && \
    unzip "${FILE}" -d /opt/tf-plugins

### Install terraform random provider
RUN FILE="terraform-provider-random_${TF_PROVIDER_RANDOM_VERSION}_linux_amd64.zip" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform-provider-random/${TF_PROVIDER_RANDOM_VERSION}/${FILE}" && \
    unzip "${FILE}" -d /opt/tf-plugins

# Checkout Hub CLI Extensions
FROM alpine/git:latest as hub-extensions
ARG HUB_EXTENSIONS_VERSION="stable"
WORKDIR /tmp
RUN git clone https://github.com/agilestacks/hub-extensions.git && \
    cd hub-extensions && \
    git checkout ${HUB_EXTENSIONS_VERSION}

# Toolbox
FROM alpine:3.15
ARG USER_FULLNAME="Agile Stacks"
ARG TOOLBOX_VERSION="(unknown)"
ARG HUB_CLI_VERSION="master"
ARG HUB_EXTENSIONS_VERSION="stable"
ARG HUB_STATE_VERSION="master"

LABEL maintainer="${USER_FULLNAME}"
LABEL toolbox="${TOOLBOX_VERSION}"
LABEL hub="${HUB_CLI_VERSION}"
LABEL extensions="${HUB_EXTENSIONS_VERSION}"
LABEL state="${HUB_STATE_VERSION}}"

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/google-cloud-sdk/bin

ENV LANG             "C.UTF-8"

ENV USER             "root"
ENV UID              "0"
ENV GID              "0"

ENV TF_PLUGIN_CACHE_DIR "/root/.terraform.d/plugin-cache"

ENV GIT_DISCOVERY_ACROSS_FILESYSTEM "1"

RUN \
    apk update && apk --no-cache --prune upgrade && \
    apk --no-cache add \
        bash \
        curl \
        git \
        gnupg \
        libc6-compat \
        nodejs \
        npm \
        ncurses \
        openssh-client \
        python3 \
        py3-pip \
        py3-virtualenv \
        py3-crcmod \
        py3-openssl \
        sed \
        vim \
        wget \
        zip

COPY --from=blobs           /usr/local/bin               /usr/local/bin
COPY --from=blobs           /opt/tf-plugins              ${TF_PLUGIN_CACHE_DIR}/linux_amd64/
COPY --from=blobs           /opt/tf-custom-plugins       /root/.terraform.d/plugins/linux_amd64/
COPY --from=blobs           /usr/local/google-cloud-sdk  /usr/local/google-cloud-sdk
COPY --from=hub-extensions  /tmp/hub-extensions          /usr/local/share/hub

RUN chmod +x /usr/local/bin/* && \
    gosu nobody true && \
    rm -rf /var/cache/apk/* /tmp/*

RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true

RUN gcloud components install beta --quiet && \
    rm -rf /usr/local/google-cloud-sdk/.install/.backup && \
    find /usr/local/google-cloud-sdk/ -type d -iname "__pycache__" -exec rm -rf {} + -prune && \
    gcloud --version

RUN echo "${TOOLBOX_VERSION}, hub cli ${HUB_CLI_VERSION}, extensions ${HUB_EXTENSIONS_VERSION}, state ${HUB_STATE_VERSION}" > /etc/version
RUN cd /usr/local/share/hub && ./post-install

RUN mkdir /workspace
WORKDIR /workspace

CMD ["/bin/bash", "--rcfile", "/etc/bashrc"]
