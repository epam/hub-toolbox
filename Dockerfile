FROM alpine:3.11 as blobs
RUN apk update && \
    apk add zip gzip unzip tar curl jq

ARG DIRENV_VERSION="2.21.2"
ARG ETCD_VERSION="3.3.18"
ARG GOSU_VERSION="1.12"
ARG HELM2_VERSION="2.16.10"
ARG HELM3_VERSION="3.3.0"
ARG HEPTIO_VERSION="1.15.10/2020-02-22"
ARG KFCTL_VERSION="v1.0.2"
ARG KOMPOSE_VERSION="1.9.0"
ARG KSONNET_VERSION="0.13.1"
ARG KUBECTL_VERSION="1.17.11"
ARG EKSCTL_VERSION="0.26.0"
ARG OC_VERSION="3.11.0-0cbc58b"
ARG STERN_VERSION="1.10.0"
ARG TF_11_VERSION="0.11.14"
ARG TF_12_VERSION="0.12.28"
ARG TINI_VERSION="0.16.1"
ARG VAULT_VERSION="1.3.2"
ARG YQ_VERSION="2.4.1"
ARG ISTIOCTL_VERSION="1.5.2"

ARG TF_PROVIDER_ARCHIVE_VERSION="1.2.2"
ARG TF_PROVIDER_AWS_VERSION_0="2.61.0"
ARG TF_PROVIDER_AWS_VERSION_1="1.60.0"
ARG TF_PROVIDER_AWS_VERSION_2="2.14.0"
ARG TF_PROVIDER_AWS_VERSION_3="2.49.0"
ARG TF_PROVIDER_AZURE_VERSION_0="1.43.0"
ARG TF_PROVIDER_AZURE_VERSION_1="2.2.0"
ARG TF_PROVIDER_EXTERNAL_VERSION="1.1.2"
ARG TF_PROVIDER_GOOGLE_VERSION="2.20.1"
ARG TF_PROVIDER_IGNITION_VERSION="1.1.0"
ARG TF_PROVIDER_KUBERNETES_VERSION="1.9.0"
ARG TF_PROVIDER_LOCAL_VERSION="1.4.0"
ARG TF_PROVIDER_NULL_VERSION="2.1.2"
ARG TF_PROVIDER_TEMPLATE_VERSION="2.1.2"
ARG TF_PROVIDER_TLS_VERSION="2.0.1"
ARG TF_PROVIDER_RANDOM_VERSION="2.1.2"

RUN mkdir -p /opt/tf-plugins \
    /opt/tf-custom-plugins

WORKDIR /usr/local/bin/

RUN FILE=aws-iam-authenticator && \
    test ! -f $FILE && curl -J -L -O \
    https://amazon-eks.s3-us-west-2.amazonaws.com/${HEPTIO_VERSION}/bin/linux/amd64/aws-iam-authenticator

RUN FILE=direnv && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64

RUN FILE=tini && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64

RUN FILE=kompose && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/kubernetes/kompose/releases/download/v${KOMPOSE_VERSION}/kompose-linux-amd64

RUN FILE=gosu && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64

RUN FILE=hal && \
    test ! -f $FILE && curl -J -L -O \
    https://raw.githubusercontent.com/spinnaker/halyard/master/startup/debian/hal

RUN FILE=kubectl && \
    test ! -f $FILE && curl -J -L -O \
    https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl

RUN FILE=yq && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64

RUN FILE=stern && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64

RUN FILE=mc && \
    test ! -f $FILE && curl -J -L -O \
    https://dl.min.io/client/$FILE/release/linux-amd64/$FILE

RUN FILE=skaffold && \
    test ! -f $FILE && curl -J -L -o $FILE \
    https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64

WORKDIR /opt/tar

RUN FILE=ks_${KSONNET_VERSION}_linux_amd64.tar.gz && \
    test ! -f $FILE && curl -J -L -O \
    https://github.com/ksonnet/ksonnet/releases/download/v${KSONNET_VERSION}/$FILE && \
    tar xvzf $FILE ks_${KSONNET_VERSION}_linux_amd64/ks --strip-components=1 && \
    mv ks /usr/local/bin

RUN DOWNLOAD_URL="$(curl -s https://api.github.com/repos/kubeflow/kfctl/releases/tags/${KFCTL_VERSION} \
    | jq -rM '.assets[] | select(.name | contains("linux")).browser_download_url')" \
    FILE="$(basename $DOWNLOAD_URL)" && \
    test ! -f $FILE && curl -JLO "${DOWNLOAD_URL}"; \
    tar xvzf "${FILE}" ./kfctl && \
    mv kfctl /usr/local/bin

RUN FILE=etcd-v${ETCD_VERSION}-linux-amd64.tar.gz && \
    test ! -f $FILE && curl -J -L -O \
    https://github.com/etcd-io/etcd/releases/download/v${ETCD_VERSION}/$FILE && \
    tar xvzf $FILE etcd-v${ETCD_VERSION}-linux-amd64/etcdctl --strip-components=1 && \
    mv etcdctl /usr/local/bin

RUN FILE=helm-v${HELM2_VERSION}-linux-amd64.tar.gz && \
    test ! -f $FILE && curl -J -L -O \
    https://storage.googleapis.com/kubernetes-helm/$FILE && \
    tar xvzf $FILE linux-amd64/helm --strip-components=1 && \
    mv helm /usr/local/bin

RUN FILE=helm-v${HELM3_VERSION}-linux-amd64.tar.gz && \
  test ! -f $FILE && curl -JLO \
  https://get.helm.sh/$FILE && \
  tar xvzf $FILE linux-amd64/helm --strip-components=1 && \
  mv helm /usr/local/bin/helm3

RUN FILE=eksctl_Linux_amd64.tar.gz && \
  test ! -f $FILE && curl -JLO \
  https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/$FILE && \
  tar xvzf $FILE eksctl && \
  mv eksctl /usr/local/bin

RUN FILE=openshift-origin-client-tools-v${OC_VERSION}-linux-64bit.tar.gz && \
    test ! -f $FILE && curl -J -L -O \
    https://github.com/openshift/origin/releases/download/v$(echo ${OC_VERSION} | cut -d- -f1)/$FILE && \
    tar xvzf $FILE openshift-origin-client-tools-v${OC_VERSION}-linux-64bit/oc --strip-components=1 && \
    mv oc /usr/local/bin

RUN FILE=istio-${ISTIOCTL_VERSION}-linux.tar.gz && \
    test ! -f $FILE && curl -J -L -O \
    https://github.com/istio/istio/releases/download/${ISTIOCTL_VERSION}/$FILE && \
    tar xvzf $FILE istio-${ISTIOCTL_VERSION}/bin/istioctl --strip-components=2 && \
    mv istioctl /usr/local/bin

WORKDIR /opt/zip

RUN FILE=terraform_${TF_11_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform/${TF_11_VERSION}/terraform_${TF_11_VERSION}_linux_amd64.zip && \
    unzip $FILE -d /usr/local/bin && mv /usr/local/bin/terraform /usr/local/bin/terraform-v0.11

RUN FILE=terraform_${TF_12_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform/${TF_12_VERSION}/terraform_${TF_12_VERSION}_linux_amd64.zip && \
    unzip $FILE -d /usr/local/bin && mv /usr/local/bin/terraform /usr/local/bin/terraform-v0.12

RUN FILE=terraform-provider-archive_${TF_PROVIDER_ARCHIVE_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-archive/${TF_PROVIDER_ARCHIVE_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-aws_${TF_PROVIDER_AWS_VERSION_0}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-aws/${TF_PROVIDER_AWS_VERSION_0}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-aws_${TF_PROVIDER_AWS_VERSION_1}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-aws/${TF_PROVIDER_AWS_VERSION_1}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-aws_${TF_PROVIDER_AWS_VERSION_2}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-aws/${TF_PROVIDER_AWS_VERSION_2}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-aws_${TF_PROVIDER_AWS_VERSION_3}_linux_amd64.zip && \
  test ! -f $FILE && curl -J -L -O \
  https://releases.hashicorp.com/terraform-provider-aws/${TF_PROVIDER_AWS_VERSION_3}/$FILE && \
  unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-azurerm_${TF_PROVIDER_AZURE_VERSION_0}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-azurerm/${TF_PROVIDER_AZURE_VERSION_0}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-azurerm_${TF_PROVIDER_AZURE_VERSION_1}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-azurerm/${TF_PROVIDER_AZURE_VERSION_1}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-external_${TF_PROVIDER_EXTERNAL_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-external/${TF_PROVIDER_EXTERNAL_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-google_${TF_PROVIDER_GOOGLE_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-google/${TF_PROVIDER_GOOGLE_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-google-beta_${TF_PROVIDER_GOOGLE_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-google-beta/${TF_PROVIDER_GOOGLE_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-ignition_${TF_PROVIDER_IGNITION_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-ignition/${TF_PROVIDER_IGNITION_VERSION}/$FILE && \
    unzip $FILE -d /opt/tf-plugins

RUN FILE=terraform-provider-kubernetes_${TF_PROVIDER_KUBERNETES_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/terraform-provider-kubernetes/${TF_PROVIDER_KUBERNETES_VERSION}/$FILE && \
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

RUN FILE=vault_${VAULT_VERSION}_linux_amd64.zip && \
    test ! -f $FILE && curl -J -L -O \
    https://releases.hashicorp.com/vault/${VAULT_VERSION}/$FILE && \
    unzip $FILE -d /usr/local/bin

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
FROM golang:1.14-alpine as hub
RUN apk update && apk upgrade && \
    apk add --no-cache git make sed
WORKDIR /go/src/hub
COPY --from=hub-scm /workspace/go.sum /workspace/go.mod ./
RUN go mod download
COPY --from=hub-scm /workspace ./
RUN make get

### Checkout Hub CLI Extensions
FROM alpine/git:latest as hub-extensions
ARG HUB_CLI_EXTENSIONS_VERSION="(unknown)"
WORKDIR /tmp
RUN git clone https://github.com/agilestacks/hub-extensions.git && \
    cd hub-extensions && \
    git checkout $HUB_CLI_EXTENSIONS_VERSION

### Build Jsonnet
FROM golang:1.13-alpine as jsonnet
RUN apk update && apk upgrade && \
    apk add --no-cache git
RUN go get github.com/google/go-jsonnet/cmd/jsonnet

### Dind
FROM docker:dind as dind

### Toolbox
FROM alpine:3.11
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

ENV STATE_BUCKET     "terraform.agilestacks.io"
ENV STATE_REGION     "us-east-1"
ENV TF_INPUT         "0"
ENV RELEASE_TRACK    "stable"
ENV LANG             "C.UTF-8"
ENV DOCKER_DAEMON_ARGS "-D"
ENV HELM_INSTALL_DIR "/usr/local/bin"

ENV USER             "root"
ENV UID              "0"
ENV GID              "0"

ENV TF_PLUGIN_CACHE_DIR "/root/.terraform.d/plugin-cache"

ENV GIT_DISCOVERY_ACROSS_FILESYSTEM "1"

COPY --from=dind /usr/local/bin/dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
COPY --from=dind /usr/local/bin/* /usr/local/bin/
RUN  mv /usr/local/bin/docker /usr/local/bin/docker-cli
COPY etc/docker  /usr/local/bin/docker

COPY --from=blobs /usr/local/bin /usr/local/bin
COPY --from=blobs /opt/tf-plugins ${TF_PLUGIN_CACHE_DIR}/linux_amd64/
COPY --from=blobs /opt/tf-custom-plugins /root/.terraform.d/plugins/linux_amd64/
COPY --from=ghub  /go/bin/ghub /usr/local/bin/ghub
COPY --from=jsonnet /go/bin/jsonnet /usr/local/bin

COPY etc/wrapdocker  /usr/local/bin/wrapdocker
COPY etc/dmsetup     /usr/local/bin/dmsetup
COPY etc/terraformrc /root/.terraformrc
COPY etc/terraformrc /usr/local/share/.terraformrc
COPY etc/bashrc      /etc/bashrc

RUN \
    apk update && apk upgrade && \
    apk add --no-cache \
    bash \
    bc \
    bind-tools \
    ca-certificates \
    curl \
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
    pwgen \
    py3-virtualenv \
    python2 \
    python3 \
    strace \
    rsync \
    sed \
    shadow \
    su-exec \
    util-linux \
    vim \
    wget \
    zip && \
    apk add --virtual=py-build gcc libffi-dev musl-dev openssl-dev python3-dev && \
    pip3 --no-cache-dir install awscli azure-cli && \
    apk del --purge py-build && \
    sed -i -e 's/^python /python3 /' /usr/bin/az && \
    chmod +x /usr/local/bin/* && \
    gosu nobody true && \
    rm -rf /var/cache/apk/* /tmp/*

RUN curl -L https://sdk.cloud.google.com | bash -s - --install-dir=/usr/local --disable-prompts && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true

RUN v=2.29-r0; wget -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$v/glibc-$v.apk && \
    apk add glibc-$v.apk && \
    rm -rf glibc-$v.apk /var/cache/apk/* /tmp/*

RUN ln -s /usr/local/bin/terraform-v0.11 /usr/local/bin/terraform

RUN groupadd -r docker && \
    usermod -aG docker $(/usr/bin/whoami)

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

WORKDIR /workspace

CMD ["/bin/bash", "--rcfile", "/etc/bashrc"]
