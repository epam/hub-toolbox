.DEFAULT_GOAL := build

IMAGE           ?= agilestacks/toolbox
TOOLBOX_VERSION := $(shell git rev-parse HEAD | cut -c-7)
HUB_CLI_VERSION := $(shell git ls-remote -q git@github.com:agilestacks/automation-hub-cli.git master | cut -c-7)
IMAGE_VERSION   ?= $(TOOLBOX_VERSION)-$(HUB_CLI_VERSION)
IMAGE_TAG       ?= latest
USER_FULLNAME   ?= $(shell id -F)
GITHUB_API_TOKEN?= $(GITHUB_TOKEN)
REGISTRY_PASS   ?= ~/.docker/agilestacks.txt

ifeq ($(USER_FULLNAME),)
$(error Please supply USER_FULLNAME with your full name (example: "USER_FULLNAME=John Doe"))
endif

ifeq ($(GITHUB_API_TOKEN),)
$(error Please supply GITHUB_API_TOKEN)
endif

docker ?= docker

DOCKER_BUILD_OPTS :=

deploy: build push

pull-from:
	docker pull alpine/git
	docker pull golang:1.13-alpine
	docker pull docker:dind
	docker pull alpine:3.10
.PHONY: pull-from

build:
	$(docker) build \
		$(DOCKER_BUILD_OPTS) \
		--build-arg="FULLNAME=$(USER_FULLNAME)"\
		--build-arg="GITHUB_TOKEN=$(GITHUB_API_TOKEN)" \
		--build-arg="IMAGE_VERSION=$(IMAGE_VERSION)" \
		--build-arg="TOOLBOX_VERSION=$(TOOLBOX_VERSION)" \
		--build-arg="HUB_CLI_VERSION=$(HUB_CLI_VERSION)" \
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
