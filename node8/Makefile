.DEFAULT_GOAL := run

IMAGE         ?= agilestacks/toolbox
IMAGE_VERSION ?= node8-$(shell git rev-parse HEAD | cut -c-7)
IMAGE_TAG     ?= node8

REGISTRY_PASS ?= ~/.docker/agilestacks.txt

docker ?= docker

DOCKER_BUILD_OPTS := --no-cache
NODEJS_VERSION := 8.11.4-r0

build:
	$(docker) build \
	$(DOCKER_BUILD_OPTS) \
	--build-arg="NODEJS_VERSION=$(NODEJS_VERSION)" \
	--tag $(IMAGE):$(IMAGE_VERSION) \
	--tag $(IMAGE):$(IMAGE_TAG) .
.PHONY: build

push: login
	$(docker) push $(IMAGE):$(IMAGE_VERSION)
	$(docker) push $(IMAGE):$(IMAGE_TAG)
.PHONY: push

login:
	@ touch $(REGISTRY_PASS)
	@ echo "Please put Docker Hub password into $(REGISTRY_PASS)"
	cat $(REGISTRY_PASS) | docker login --username agilestacks --password-stdin
.PHONY: login

run:
	$(docker) run --rm -it -v $(shell pwd):$(shell pwd) -p 3000:$(PORT) agilestacks/toolbox:wetty
.PHONY: run
