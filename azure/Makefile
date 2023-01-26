.DEFAULT_GOAL := build

IMAGE         ?= ghcr.io/epam/hub-toolbox
IMAGE_VERSION ?= $(shell git rev-parse HEAD | cut -c-7)-azure

docker ?= docker

DOCKER_BUILD_OPTS := --platform="linux/amd64"

build:
	$(docker) buildx build \
		$(DOCKER_BUILD_OPTS) \
		--tag $(IMAGE):$(IMAGE_VERSION) \
		--tag $(IMAGE):latest .;
.PHONY: build

push:
	$(docker) push $(IMAGE):$(IMAGE_VERSION)
	$(docker) push $(IMAGE):latest
.PHONY: push

run:
	$(docker) run --rm -it $(IMAGE):latest
.PHONY: run

