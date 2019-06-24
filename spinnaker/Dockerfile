FROM openjdk:8 as halyard

ARG HALYARD_VERSION=1.11
ENV GRADLE_USER_HOME cache
WORKDIR /workdir
RUN \
  apt-get update && apt-get install git && \
  git clone --recursive -b release-${HALYARD_VERSION}.x https://github.com/spinnaker/halyard.git $PWD && \
  ./gradlew installDist --info --stacktrace -x test -Prelease.version=${HALYARD_VERSION}.1 && \
  cp -r ./halyard-web/build/install/halyard /opt


FROM docker.io/agilestacks/toolbox:latest

ARG JAVA_VERSION="8.212.04-r0"

ENV JAVA_HOME "/usr/lib/jvm/java-1.8-openjdk/jre"
ENV PATH      "$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin"
ENV UID       "1000"
ENV GID       "1000"
ENV USER      "spinnaker"
ENV HOME      "/home/spinnaker"
ENV HAL_USER  "spinnaker"

ENV TOOLBOX_NO_DOCKER "1"

COPY --from=halyard /opt/halyard /opt/halyard
COPY etc/docker-java-home /usr/local/bin/docker-java-home

RUN \
    mkdir -p /var/log/spinnaker/halyard && \
    apk update && apk upgrade && \
    apk add --no-cache openjdk8-jre="$JAVA_VERSION" && \
        [ "$JAVA_HOME" = "$(docker-java-home)" ] && \
    rm -rf /var/cache/apk/* /tmp/*

RUN chown -R 1000:1000 /opt/halyard /var/log/spinnaker
