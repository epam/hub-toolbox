.DEFAULT_GOAL := run

IMAGE         ?= agilestacks/toolbox
IMAGE_VERSION ?= sandbox-$(shell git rev-parse HEAD | cut -c-7)
IMAGE_TAG     ?= sandbox

REGISTRY_PASS ?= ~/.docker/agilestacks.txt

docker ?= docker

DOCKER_BUILD_OPTS := --no-cache

build:
	$(docker) build \
	$(DOCKER_BUILD_OPTS) \
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
