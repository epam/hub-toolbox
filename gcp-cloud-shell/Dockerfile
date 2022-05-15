### Checkout Hub CLI Extensions
FROM alpine/git:latest as hub-extensions
ARG HUB_EXTENSIONS_VERSION="master"

WORKDIR /tmp
RUN git clone https://github.com/agilestacks/hub-extensions.git && \
    cd hub-extensions && \
    git checkout $HUB_EXTENSIONS_VERSION

### Checkout hub-state tool
FROM alpine/git:latest as hub-state-scm
ARG HUB_STATE_VERSION="master"

WORKDIR /workspace
RUN git clone https://github.com/agilestacks/hub-state.git && \
    cd hub-state/cli && \
    git checkout $HUB_STATE_VERSION

### Build hub-state tool
FROM gcr.io/cloudshell-images/cloudshell:latest as hub-state
RUN apt-get update
WORKDIR /workspace
COPY --from=hub-state-scm /workspace/hub-state/cli /workspace
RUN make build
RUN chmod +x bin/hub-state

### Checkout kubectx & kubens
FROM alpine/git:latest as kube-tools

WORKDIR /tmp
RUN git clone https://github.com/ahmetb/kubectx && \
    cd kubectx

FROM gcr.io/cloudshell-images/cloudshell:latest
ARG YQ_VERSION="v4.16.2"
ARG HUB_CLI_RELEASE_VERSION="v1.0.3"
ARG JQ_VERSION="1.6"
ARG K6_VERSION="v0.37.0"
ARG XK6_VERSION="0.6.1"

### Install missing packages
RUN apt-get update && \
    apt-get install uuid-runtime netcat -y

### Install Hub CLI
RUN curl -J -L -o hub https://github.com/agilestacks/hub/releases/download/"$HUB_CLI_RELEASE_VERSION"/hub.linux_amd64 && \
    chmod +x hub && \
    mv hub /usr/local/bin

### Install extensions
COPY --from=hub-extensions /tmp/hub-extensions /usr/local/share/hub

### Install yq
RUN curl -J -L -o yq https://github.com/mikefarah/yq/releases/download/"$YQ_VERSION"/yq_linux_amd64 && \
    chmod +x yq && \
    mv yq /usr/local/bin

### Install jq 
RUN curl -J -L -o jq https://github.com/stedolan/jq/releases/download/jq-"$JQ_VERSION"/jq-linux64 && \
    chmod +x jq && \
    mv jq /usr/local/bin

### Install k6
 RUN curl -J -L -o k6.tar.gz https://github.com/grafana/k6/releases/download/"$K6_VERSION"/k6-"$K6_VERSION"-linux-amd64.tar.gz && \
    tar -xf k6.tar.gz --strip-components 1 && \
    chmod +x k6 && \
    mv k6 /usr/local/bin && \
    rm k6.tar.gz

### Install k6x
 RUN curl -J -L -o xk6.tar.gz https://github.com/grafana/xk6/releases/download/v"$XK6_VERSION"/xk6_"$XK6_VERSION"_linux_amd64.tar.gz && \
    tar -xf xk6.tar.gz xk6 && \
    chmod +x xk6 && \
    mv xk6 /usr/local/bin && \
    rm xk6.tar.gz    

### Install kubectx & kubens
COPY --from=kube-tools /tmp/kubectx/kubectx /usr/local/bin
COPY --from=kube-tools /tmp/kubectx/kubens /usr/local/bin

COPY --from=hub-state /workspace/bin/hub-state /usr/local/share/hub
