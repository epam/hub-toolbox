FROM docker.io/agilestacks/toolbox:latest

ENV NODEJS_VERSION "8.12.0-r0"
ENV NODE_PATH "/usr/lib/node_modules"

RUN \
    apk update && apk upgrade && \
    apk add --no-cache nodejs=${NODEJS_VERSION} npm=${NODEJS_VERSION} \
        --update-cache --repository http://nl.alpinelinux.org/alpine/edge/main && \
    rm -rf /var/cache/apk/* /tmp/*
RUN npm install -g js-yaml
