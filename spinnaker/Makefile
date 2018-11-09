.DEFAULT_GOAL := build

IMAGE         ?= agilestacks/toolbox
IMAGE_VERSION ?= spinnaker-$(shell git rev-parse HEAD | cut -c-7)
IMAGE_TAG     ?= spinnaker

REGISTRY_PASS ?= ~/.docker/agilestacks.txt

docker ?= docker

DOCKER_BUILD_OPTS :=

deploy: build push

build:
	$(docker) build \
	$(DOCKER_BUILD_OPTS) \
	--tag $(IMAGE):$(IMAGE_VERSION) \
	--tag $(IMAGE):$(IMAGE_TAG) .
.PHONY: build

build-no-cache:
	$(MAKE) build DOCKER_BUILD_OPTS="--no-cache"
.PHONY: build-no-cache

push: login push-version push-tag
.PHONY: push

push-version:
	$(docker) push $(IMAGE):$(IMAGE_VERSION)
.PHONY: push-version

push-tag:
	$(docker) tag $(IMAGE):$(IMAGE_VERSION) $(IMAGE):$(IMAGE_TAG)
	$(docker) push $(IMAGE):$(IMAGE_TAG)
.PHONY: push-tag

pull-latest:
	docker pull $(IMAGE):spinnaker
.PHONY: pull-latest

push-stable: pull-latest
	$(MAKE) push-tag IMAGE_VERSION=spinnaker IMAGE_TAG=spinnaker-stable
.PHONY: push-stable

push-stage: pull-latest
	$(MAKE) push-tag IMAGE_VERSION=spinnaker IMAGE_TAG=spinnaker-stage
.PHONY: push-stage

push-preview: pull-latest
	$(MAKE) push-tag IMAGE_VERSION=spinnaker IMAGE_TAG=spinnaker-preview
.PHONY: push-preview

run:
	$(docker) run --rm -it -v $(shell pwd):$(shell pwd) $(IMAGE):$(IMAGE_TAG)
.PHONY: run

login:
	@ touch $(REGISTRY_PASS)
	@ echo "Please put Docker Hub password into $(REGISTRY_PASS)"
	cat $(REGISTRY_PASS) | docker login --username agilestacks --password-stdin
.PHONY: login
