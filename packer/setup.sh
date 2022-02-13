#!/bin/bash

HELM_VERSION=3.8.0-1
TERRAFORM_VERSION=1.1.5
KUBECTL_VERSION=1.21.9-00
GCLOUD_VERSION=372.0.0-0
YQ_VERSION=v4.6.3

export DEBIAN_FRONTEND=noninteractive 
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

## Wait until boot is completed
cloud-init status --wait

sudo apt-get update -q

## Install tools
sudo apt-get install -yq \
    apt-utils \
    apt-transport-https \
    gnupg \
    software-properties-common \
    bc \
    ca-certificates \
    curl \
    docker \
    gettext \
    git \
    jq \
    make \
    nodejs \
    npm \
    openssl \
    sed \
    tar \
    vim \
    wget \
    coreutils \
    zip

## Add Helm Pub key & Repo: https://helm.sh/docs/intro/install/#from-apt-debianubuntu
curl https://baltocdn.com/helm/signing.asc | (OUT=$(sudo apt-key add - 2>&1) || echo "$OUT")
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

## Add Terrform Pub key & Repo: https://learn.hashicorp.com/tutorials/terraform/install-cli
curl https://apt.releases.hashicorp.com/gpg | (OUT=$(sudo apt-key add - 2>&1) || echo "$OUT")
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

## Add kubectl Pub key & Repo: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

## Add gcloud Pub key & Repo: https://cloud.google.com/sdk/docs/install#deb
sudo curl -fsSLo /usr/share/keyrings/cloud.google.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

## Installing terraform helm kubectl gcloud
sudo apt-get update -q
sudo apt-get install -yq \
    terraform="$TERRAFORM_VERSION" \
    helm="$HELM_VERSION" \
    kubectl="$KUBECTL_VERSION" \
    google-cloud-sdk="$GCLOUD_VERSION" 

## Install yq
curl -J -L -o yq https://github.com/mikefarah/yq/releases/download/"$YQ_VERSION"/yq_linux_amd64
chmod +x yq
sudo mv yq /usr/local/bin

## Install Superhub CLI with extensions
curl -L -O https://github.com/agilestacks/hub/releases/download/v1.0.2/hub.linux_amd64
mv hub.linux_amd64 hub
chmod +x hub
sudo mv hub /usr/local/bin

## kubectx && kubens
git clone https://github.com/ahmetb/kubectx
cd kubectx || return
chmod +x kubectx
chmod +x kubens
sudo mv kubectx /usr/local/bin
sudo mv kubens /usr/local/bin
cd .. 
rm -rf kubectx/
