FROM alpine:3.15 as blobs
RUN apk update && \
    apk add zip gzip unzip tar curl jq git

ARG DIRENV_VERSION="2.30.3"
ARG GOSU_VERSION="1.14"
ARG HELM3_VERSION="3.8.0"
ARG KUBECTL_VERSION="1.22.6"
ARG TF_10_VERSION="1.1.5"
ARG TINI_VERSION="0.19.0"
ARG YQ_VERSION="v4.6.3"

ARG TF_PROVIDER_GOOGLE_VERSION_0="4.10.0"
ARG TF_PROVIDER_LOCAL_VERSION="2.1.0"
ARG TF_PROVIDER_NULL_VERSION="3.1.0"
ARG TF_PROVIDER_TEMPLATE_VERSION="2.2.0"
ARG TF_PROVIDER_TLS_VERSION="3.1.0"
ARG TF_PROVIDER_RANDOM_VERSION="3.1.0"

RUN mkdir -p /opt/tf-plugins \
    /opt/tf-custom-plugins

WORKDIR /usr/local/bin/

RUN FILE=direnv && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64

RUN FILE=tini && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64

RUN FILE=gosu && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64

RUN FILE=kubectl && \
    test ! -f $FILE && curl -J -L -O \
    https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl

RUN FILE=yq && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64

WORKDIR /opt/tar

RUN FILE=helm-v${HELM3_VERSION}-linux-amd64.tar.gz && \
  test ! -f $FILE && curl -JLO \
  https://get.helm.sh/$FILE && \
  tar xvzf $FILE linux-amd64/helm --strip-components=1 && \
  mv helm /usr/local/bin

WORKDIR /opt/zip

RUN FILE=terraform_${TF_10_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform/${TF_10_VERSION}/terraform_${TF_10_VERSION}_linux_amd64.zip && \
    unzip $FILE -d /usr/local/bin && mv /usr/local/bin/terraform /usr/local/bin/terraform-v1.0

RUN FILE=terraform-provider-google_${TF_PROVIDER_GOOGLE_VERSION_0}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-google/${TF_PROVIDER_GOOGLE_VERSION_0}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-local_${TF_PROVIDER_LOCAL_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-local/${TF_PROVIDER_LOCAL_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-null_${TF_PROVIDER_NULL_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-null/${TF_PROVIDER_NULL_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-template_${TF_PROVIDER_TEMPLATE_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-template/${TF_PROVIDER_TEMPLATE_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-tls_${TF_PROVIDER_TLS_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-tls/${TF_PROVIDER_TLS_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-random_${TF_PROVIDER_RANDOM_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-random/${TF_PROVIDER_RANDOM_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

WORKDIR /tmp

RUN git clone https://github.com/ahmetb/kubectx && \
    cd kubectx && \
    mv kubectx /usr/local/bin && \
    mv kubens /usr/local/bin

### Checkout github
FROM alpine/git:latest as ghub-scm
ARG GHUB_VERSION="2.14.1"
WORKDIR /go/src/github.com/github
RUN git clone -b v${GHUB_VERSION} https://github.com/github/hub.git

### Build github
FROM golang:1.13-alpine as ghub
COPY --from=ghub-scm /go /go
RUN apk update && apk upgrade && \
    apk add --no-cache git bash
WORKDIR /go/src/github.com/github/hub
RUN script/build -o /go/bin/ghub

### Checkout Hub CLI
FROM alpine/git:latest as hub-scm
ARG HUB_CLI_VERSION="(unknown)"
WORKDIR /workspace
RUN git init && \
    git remote add -f origin https://github.com/agilestacks/hub.git && \
    git pull --depth=1 origin master && \
    git checkout $HUB_CLI_VERSION

### Build Hub CLI
FROM golang:1.15-alpine as hub
RUN apk update && apk upgrade && \
    apk add --no-cache git make sed
WORKDIR /go/src/hub
COPY --from=hub-scm /workspace/go.sum /workspace/go.mod ./
RUN go mod download
COPY --from=hub-scm /workspace ./
RUN --mount=type=secret,id=ddkey --mount=type=secret,id=mskey \
    make get DD_CLIENT_API_KEY=$(cat /run/secrets/ddkey) METRICS_API_SECRET=$(cat /run/secrets/mskey)

### Checkout Hub CLI Extensions
FROM alpine/git:latest as hub-extensions
ARG HUB_CLI_EXTENSIONS_VERSION="(unknown)"
WORKDIR /tmp
RUN git clone https://github.com/agilestacks/hub-extensions.git && \
    cd hub-extensions && \
    git checkout $HUB_CLI_EXTENSIONS_VERSION

### Toolbox
FROM alpine:3.15
ARG FULLNAME="Agile Stacks"
ARG IMAGE_VERSION="(unknown)"
ARG TOOLBOX_VERSION="(unknown)"
ARG HUB_CLI_VERSION="(unknown)"
ARG HUB_CLI_EXTENSIONS_VERSION="(unknown)"

LABEL maintainer="${FULLNAME} <support@agilestacks.com>"
LABEL toolbox="${TOOLBOX_VERSION}"
LABEL hub="${HUB_CLI_VERSION}"
LABEL extensions="${HUB_CLI_EXTENSIONS_VERSION}"

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/google-cloud-sdk/bin

ENV LANG             "C.UTF-8"

ENV USER             "root"
ENV UID              "0"
ENV GID              "0"

ENV TF_PLUGIN_CACHE_DIR "/root/.terraform.d/plugin-cache"

ENV GIT_DISCOVERY_ACROSS_FILESYSTEM "1"

COPY --from=blobs /usr/local/bin /usr/local/bin
COPY --from=blobs /opt/tf-plugins ${TF_PLUGIN_CACHE_DIR}/linux_amd64/
COPY --from=blobs /opt/tf-custom-plugins /root/.terraform.d/plugins/linux_amd64/
COPY --from=ghub  /go/bin/ghub /usr/local/bin/ghub

RUN \
    apk update && apk upgrade && \
    apk add --no-cache \
        bash \
        bc \
        bind-tools \
        ca-certificates \
        curl \
        docker \
        e2fsprogs \
        expat \
        gettext \
        git \
        git-subtree \
        gnupg \
        iptables \
        jq \
        less \
        libgcc \
        libstdc++ \
        lxc \
        make \
        nano \
        nodejs \
        npm \
        openssh \
        openssl \
        parallel \
        pwgen \
        py3-pip \
        py3-virtualenv \
        python2 \
        python3 \
        strace \
        rsync \
        sed \
        shadow \
        su-exec \
        tar \
        util-linux \
        vim \
        wget \
        coreutils \
        ncurses \
        zip

RUN chmod +x /usr/local/bin/* && \
    gosu nobody true && \
    rm -rf /var/cache/apk/* /tmp/*

RUN curl -L https://sdk.cloud.google.com | bash -s - --install-dir=/usr/local --disable-prompts && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true

RUN v=2.33-r0; wget -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$v/glibc-$v.apk && \
    apk add glibc-$v.apk && \
    rm -rf glibc-$v.apk /var/cache/apk/* /tmp/*

RUN ln -s terraform-v1.0 /usr/local/bin/terraform

VOLUME /var/lib/docker
ENTRYPOINT ["/usr/local/bin/entrypoint"]
COPY etc/entrypoint /usr/local/bin/entrypoint
COPY etc/virtualenv-2.7 /usr/local/bin/virtualenv-2.7
RUN chmod go+rx /root

RUN echo "${TOOLBOX_VERSION}, hub cli ${HUB_CLI_VERSION}, extensions ${HUB_CLI_EXTENSIONS_VERSION}" > /etc/version
ENV TOOLBOX_VERSION "${IMAGE_VERSION}"
COPY --from=hub /go/src/hub/bin/linux/hub /usr/local/bin/hub
COPY --from=hub-extensions /tmp/hub-extensions /usr/local/share/hub
RUN cd /usr/local/share/hub && ./post-install

RUN mkdir /workspace
WORKDIR /workspace

CMD ["/bin/bash", "--rcfile", "/etc/bashrc"]
