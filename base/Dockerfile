FROM alpine:3.15 as blobs
RUN apk update && \
    apk add zip gzip unzip tar curl

ARG DIRENV_VERSION="2.32.1"
ARG HELM3_VERSION="3.9.0"
ARG KUBECTL_VERSION="1.24.2"
ARG TF_VERSION="1.2.4"
ARG TINI_VERSION="0.19.0"
ARG JQ_VERSION="1.6"
ARG YQ_VERSION="4.25.3"
ARG KUSTOMIZE_VERSION="4.5.5"
ARG HUB_CLI_VERSION="1.0.9"
ARG HUB_STATE_VERSION="1.0.0"
ARG GITHUB_CLI_VERSION="2.13.0"

# Tools binaries
WORKDIR /usr/local/bin/

### Install direnv
RUN FILE="direnv" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64"

### Install tini
RUN FILE="tini" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64"

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

# Tar base tools
WORKDIR /opt/tar

### Install helm
RUN FILE="helm-v${HELM3_VERSION}-linux-amd64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://get.helm.sh/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ --strip-components=1 linux-amd64/helm

### Install Hub CLI
RUN FILE="hub_Linux_x86_64.tar.gz" && \
    test ! -f "${FILE}" && curl --fail -J -L -o "${FILE}" \
    "https://github.com/agilestacks/hub/releases/download/v${HUB_CLI_VERSION}/${FILE}" && \
    tar xzf "${FILE}" -C /usr/local/bin/ hub

### Install Github CLI
RUN FILE="gh_${GITHUB_CLI_VERSION}_linux_amd64" && \
    test ! -f "${FILE}.tar.gz" && curl --fail -J -L -o "${FILE}.tar.gz" \
    "https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/${FILE}.tar.gz" && \
    tar xzf "${FILE}.tar.gz" -C /usr/local/bin/ --strip-components=2 ${FILE}/bin/gh

### Install Kustomize
RUN FILE="kustomize_v${KUSTOMIZE_VERSION}_linux_amd64" && \
    test ! -f "${FILE}.tar.gz" && curl --fail -J -L -o "${FILE}.tar.gz" \
    "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/${FILE}.tar.gz" && \
    tar xzf "${FILE}.tar.gz" -C /usr/local/bin/ kustomize

### Zip based tools
WORKDIR /opt/zip

### Install terraform
RUN FILE="terraform_${TF_VERSION}_linux_amd64.zip" && \
    test ! -f "${FILE}" && curl --fail -J -L -O \
    "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" && \
    unzip "${FILE}" -d /usr/local/bin

### Checkout Hub CLI Extensions
FROM alpine/git:v2.36.1 as hub-extensions
ARG HUB_CLI_EXTENSIONS_VERSION="stable"
WORKDIR /tmp
RUN git clone https://github.com/agilestacks/hub-extensions.git && \
    cd hub-extensions && \
    git checkout ${HUB_EXTENSIONS_VERSION}

### Build Jsonnet
FROM golang:1.18-alpine as jsonnet
RUN apk update && apk upgrade && \
    apk add --no-cache git
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@latest

### Toolbox
FROM alpine:3.15
ARG USER_FULLNAME="Agile Stacks"
ARG TOOLBOX_VERSION="master"
ARG HUB_CLI_VERSION="master"
ARG HUB_CLI_EXTENSIONS_VERSION="stable"

LABEL maintainer="${USER_FULLNAME}"
LABEL toolbox="${TOOLBOX_VERSION}"
LABEL hub="${HUB_CLI_VERSION}"
LABEL extensions="${HUB_CLI_EXTENSIONS_VERSION}"

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV LANG             "C.UTF-8"

ENV USER             "root"
ENV UID              "0"
ENV GID              "0"

ENV GIT_DISCOVERY_ACROSS_FILESYSTEM "1"

COPY --from=blobs           /usr/local/bin      /usr/local/bin
COPY --from=jsonnet         /go/bin/jsonnet     /usr/local/bin
COPY --from=hub-extensions  /tmp/hub-extensions /usr/local/share/hub

RUN \
    apk update && apk upgrade && \
    apk add --no-cache \
        bash \
        curl \
        gettext \
        git \
        git-subtree \
        gnupg \
        gzip \
        libc6-compat \
        nodejs \
        npm \
        openssh-client \
        python3 \
        py3-pip \
        py3-virtualenv \
        py3-crcmod \
        py3-openssl \
        rsync \
        sed \
        tar \
        unzip \
        vim \
        wget \
        zip

RUN chmod +x /usr/local/bin/* && \
    rm -rf /var/cache/apk/* /tmp/*

### Post install for hub extensions
RUN cd /usr/local/share/hub && ./post-install

ENTRYPOINT ["tini", "--"]

RUN echo "${TOOLBOX_VERSION}, hub cli ${HUB_CLI_VERSION}, extensions ${HUB_CLI_EXTENSIONS_VERSION}" > /etc/version

RUN mkdir /workspace
WORKDIR /workspace

CMD ["/bin/bash", "--rcfile", "/etc/bashrc"]
