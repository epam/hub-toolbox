FROM node:0.10.38 as wetty-builder
RUN git clone https://github.com/krishnasrinivas/wetty.git /wetty
WORKDIR /wetty
RUN npm install

FROM docker.io/agilestacks/toolbox:latest

WORKDIR /
ENV NODEJS_VERSION=v0.10.48 CFLAGS="-D__USE_MISC"
ENV CONFIG_FLAGS="--without-npm" RM_DIRS=/usr/include

RUN apk add --no-cache curl make gcc g++ python linux-headers binutils-gold gnupg libstdc++ paxctl && \
  for server in ipv4.pool.sks-keyservers.net keyserver.pgp.com ha.pool.sks-keyservers.net; do \
    gpg --keyserver $server --recv-keys \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D && break; \
  done && \
  curl -o node-${NODEJS_VERSION}.tar.gz -sSL https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}.tar.gz && \
  curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/${NODEJS_VERSION}/SHASUMS256.txt.asc && \
  gpg --verify SHASUMS256.txt.asc && \
  grep node-${NODEJS_VERSION}.tar.gz SHASUMS256.txt.asc | sha256sum -c - && \
  tar -zxf node-${NODEJS_VERSION}.tar.gz && \
  cd node-${NODEJS_VERSION} && \
  export GYP_DEFINES="linux_use_gold_flags=0" && \
  ./configure --prefix=/usr ${CONFIG_FLAGS} && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
  paxctl -cm out/Release/mksnapshot && \
  make -j${NPROC} && \
  make install && \
  paxctl -cm /usr/bin/node && \
  apk del gcc g++ linux-headers paxctl gnupg ${DEL_PKGS} && \
  rm -rf /etc/ssl /node-${NODEJS_VERSION}.tar.gz /SHASUMS256.txt.asc /node-${NODEJS_VERSION} ${RM_DIRS} \
    /usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /root/.gnupg \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html

RUN git config --system http.sslverify false

COPY --from=wetty-builder /wetty /wetty
WORKDIR /wetty

# ARG user=agilestacks
# ARG password=toolbox

RUN echo "Test: agilestacks $username"

RUN useradd -d /home/agilestacks -m -s /bin/bash $username
RUN echo "agilestacks:toolbox" | chpasswd

USER agilestacks
ENV HOME /home/agilestacks

RUN mkdir -p $HOME/.ssh && chmod 700 $HOME/.ssh

COPY --chown=agilestacks insecure_private_key $HOME/.ssh/id_rsa
COPY --chown=agilestacks authorized_keys      $HOME/.ssh/authorized_keys
COPY --chown=agilestacks ssh_config           $HOME/.ssh/config
RUN chmod 600 $HOME/.ssh/id_rsa $HOME/.ssh/authorized_keys

USER root

EXPOSE 3000
ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000", "--sshuser", "term", "--sshauth", "publickey,password", "--sshhost", localhost]
