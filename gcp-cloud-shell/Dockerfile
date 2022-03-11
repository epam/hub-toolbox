### Checkout Hub CLI Extensions
FROM alpine/git:latest as hub-extensions
ARG HUB_CLI_EXTENSIONS_VERSION="master"

WORKDIR /tmp
RUN git clone https://github.com/agilestacks/hub-extensions.git && \
    cd hub-extensions && \
    git checkout $HUB_CLI_EXTENSIONS_VERSION

### Checkout kubectx & kubens
FROM alpine/git:latest as kube-tools

WORKDIR /tmp
RUN git clone https://github.com/ahmetb/kubectx && \
    cd kubectx

FROM gcr.io/cloudshell-images/cloudshell:latest
ARG YQ_VERSION="v4.16.2"
ARG HUB_BINARY_VERSION="v1.0.2"

### Install missing packages
RUN apt-get update && \
    apt-get install uuid-runtime netcat -y

### Install Hub CLI
RUN curl -J -L -o hub https://github.com/agilestacks/hub/releases/download/"$HUB_BINARY_VERSION"/hub.linux_amd64 && \
    chmod +x hub && \
    mv hub /usr/local/bin

### Install extensions
COPY --from=hub-extensions /tmp/hub-extensions /usr/local/share/hub

### Install yq
RUN curl -J -L -o yq https://github.com/mikefarah/yq/releases/download/"$YQ_VERSION"/yq_linux_amd64 && \
    chmod +x yq && \
    mv yq /usr/local/bin

### Install jq 1.6
RUN curl -J -L -o jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x jq && \
    mv jq /usr/local/bin

### Install kubectx & kubens
COPY --from=kube-tools /tmp/kubectx/kubectx /usr/local/bin
COPY --from=kube-tools /tmp/kubectx/kubens /usr/local/bin


### https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://source.developers.google.com/p/superhub/r/stacks&cloudshell_image=gcr.io/superhub/cloud-shell
