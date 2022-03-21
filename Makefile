.DEFAULT_GOAL := build

IMAGE           ?= agilestacks/toolbox
TOOLBOX_VERSION := $(shell git rev-parse HEAD | cut -c-7)
HUB_CLI_VERSION            := $(shell git ls-remote -q https://github.com/agilestacks/hub.git master 2>/dev/null | cut -c-7)
HUB_CLI_EXTENSIONS_VERSION := $(shell git ls-remote -q https://github.com/agilestacks/hub-extensions.git gcp-extensions 2>/dev/null | cut -c-7)

ifeq ($(HUB_CLI_VERSION),)
$(error HUB_CLI_VERSION cannot be empty)
endif

IMAGE_VERSION ?= $(TOOLBOX_VERSION)-$(HUB_CLI_VERSION)-$(HUB_CLI_EXTENSIONS_VERSION)
IMAGE_TAG     ?= latest
USER_FULLNAME ?= $(shell id -un)
REGISTRY_PASS ?= ~/.docker/agilestacks.txt

ifeq (,$(USER_FULLNAME))
$(error Please supply USER_FULLNAME with your full name (example: "USER_FULLNAME=John Doe"))
endif

ifeq (,$(METRICS_API_SECRET))
$(warning METRICS_API_SECRET is not set - usage metrics won't be submitted to SuperHub API; \
see https://github.com/agilestacks/documentation/wiki/Production#toolbox)
endif

ifeq (,$(DD_CLIENT_API_KEY))
$(warning DD_CLIENT_API_KEY is not set - usage metrics won't be submitted to Datadog; \
see https://github.com/agilestacks/documentation/wiki/Hub-CLI-Usage-Metrics)
endif

docker ?= docker

DOCKER_BUILD_OPTS :=

deploy: build push

pull-from:
	docker pull alpine/git
	docker pull golang:1.13-alpine
	docker pull docker:dind
	docker pull alpine:3.11
.PHONY: pull-from

export DOCKER_BUILDKIT ?= 1
# DD_CLIENT_API_KEY is optional
build:
	set -e; \
	ddkey_file=$$(mktemp); \
	mskey_file=$$(mktemp); \
	echo "$$DD_CLIENT_API_KEY" > $$ddkey_file; \
	echo "$$METRICS_API_SECRET" > $$mskey_file; \
	$(docker) build \
		$(DOCKER_BUILD_OPTS) \
		--build-arg="FULLNAME=$(USER_FULLNAME)"\
		--build-arg="IMAGE_VERSION=$(IMAGE_VERSION)" \
		--build-arg="TOOLBOX_VERSION=$(TOOLBOX_VERSION)" \
		--build-arg="HUB_CLI_VERSION=$(HUB_CLI_VERSION)" \
		--build-arg="HUB_CLI_EXTENSIONS_VERSION=$(HUB_CLI_EXTENSIONS_VERSION)" \
		--secret id=ddkey,src=$$ddkey_file \
		--secret id=mskey,src=$$mskey_file \
		--tag $(IMAGE):$(IMAGE_VERSION) \
		--tag $(IMAGE):$(IMAGE_TAG) .; \
	rm $$ddkey_file $$mskey_file
.PHONY: build

build-sandbox:
	$(MAKE) build docker="docker buildx" DOCKER_BUILD_OPTS="-f gcp-sandbox/Dockerfile --platform linux/amd64" IMAGE=gcr.io/superhub/toolbox-sandbox
.PHONY: build-sandbox

build-gcp-cloud-shell-box:
	$(MAKE) build docker="docker buildx" DOCKER_BUILD_OPTS="-f gcp-cloud-shell/Dockerfile --platform linux/amd64" HUB_BINARY_VERSION=v1.0.3 IMAGE=gcr.io/superhub/cloud-shell
.PHONY: build-gcp-cloud-shell-box

build-no-cache:
	$(MAKE) build DOCKER_BUILD_OPTS="--no-cache"
.PHONY: build-no-cache

push: login push-version push-tag
.PHONY: push

push-gcr: push-version push-tag
.PHONY: push-gcr

push-sandbox-gcr:
	@ echo "Make sure you are logged into GCR"
	$(MAKE) push-gcr IMAGE=gcr.io/superhub/toolbox-sandbox
.PHONY: push-sandbox-gcr

push-cloud-shell-box-gcr:
	@ echo "Make sure you are logged into GCR"
	$(MAKE) push-gcr IMAGE=gcr.io/superhub/cloud-shell
.PHONY: push-cloud-shell-box-gcr

push-version:
	$(docker) push $(IMAGE):$(IMAGE_VERSION)
.PHONY: push-version

push-tag:
	$(docker) tag $(IMAGE):$(IMAGE_VERSION) $(IMAGE):$(IMAGE_TAG)
	$(docker) push $(IMAGE):$(IMAGE_TAG)
.PHONY: push-tag

pull-latest:
	docker pull $(IMAGE):latest
.PHONY: pull-latest

push-stable: pull-latest
	$(MAKE) push-tag IMAGE_VERSION=latest IMAGE_TAG=stable
.PHONY: push-stable

push-stage: pull-latest
	$(MAKE) push-tag IMAGE_VERSION=latest IMAGE_TAG=stage
.PHONY: push-stage

push-preview: pull-latest
	$(MAKE) push-tag IMAGE_VERSION=latest IMAGE_TAG=preview
.PHONY: push-preview

run:
	IMAGE_VERSION=$(IMAGE_VERSION) $(SHELL) toolbox-run
.PHONY: run

login:
	@ touch $(REGISTRY_PASS)
	@ echo "Please put Docker Hub password into $(REGISTRY_PASS)"
	cat $(REGISTRY_PASS) | docker login --username agilestacks --password-stdin
.PHONY: login
