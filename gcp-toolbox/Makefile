.DEFAULT_GOAL := build

IMAGE                    ?= gcr.io/superhub/gcp-toolbox

TOOLBOX_VERSION        := $(shell git rev-parse HEAD | cut -c-7)
HUB_CLI_VERSION        := latest
HUB_EXTENSIONS_VERSION := stable
HUB_STATE_VERSION      := latest

ifeq ($(HUB_CLI_VERSION),)
$(error HUB_CLI_VERSION cannot be empty)
endif

ifeq ($(HUB_EXTENSIONS_VERSION),)
$(error HUB_EXTENSIONS_VERSION cannot be empty)
endif

ifeq ($(HUB_STATE_VERSION),)
$(error HUB_STATE_VERSION cannot be empty)
endif

ifeq ($(HUB_CLI_VERSION),latest)
HUB_CLI_VERSION = $(shell curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/agilestacks/hub/releases/latest" | jq -crM ".tag_name" | cut -c 2-)
endif

ifeq ($(HUB_STATE_VERSION),latest)
HUB_STATE_VERSION = $(shell curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/agilestacks/hub-state/releases/latest" | jq -crM ".tag_name" | cut -c 2-)
endif

HUB_CLI_VERSION_COMMIT        := $(shell git ls-remote -q https://github.com/agilestacks/hub.git            v$(HUB_CLI_VERSION)       2>/dev/null | cut -c-7)
HUB_EXTENSIONS_VERSION_COMMIT := $(shell git ls-remote -q https://github.com/agilestacks/hub-extensions.git $(HUB_EXTENSIONS_VERSION) 2>/dev/null | cut -c-7)
HUB_STATE_VERSION_COMMIT      := $(shell git ls-remote -q https://github.com/agilestacks/hub-state.git      v$(HUB_STATE_VERSION)     2>/dev/null | cut -c-7)

IMAGE_VERSION ?= $(TOOLBOX_VERSION)-$(HUB_CLI_VERSION_COMMIT)-$(HUB_EXTENSIONS_VERSION_COMMIT)-$(HUB_STATE_VERSION_COMMIT)
USER_FULLNAME ?= $(shell echo "$(shell git config user.name) <$(shell git config user.email)>")

ifeq (,$(USER_FULLNAME))
$(error Please supply USER_FULLNAME with your full name (example: "USER_FULLNAME=John Doe"))
endif

docker ?= docker

DOCKER_BUILD_OPTS := --platform="linux/amd64"

build:
	set -e; \
	$(docker) buildx build \
		$(DOCKER_BUILD_OPTS) \
		--build-arg="USER_FULLNAME=$(USER_FULLNAME)"\
		--build-arg="TOOLBOX_VERSION=$(TOOLBOX_VERSION)" \
		--build-arg="HUB_CLI_VERSION=$(HUB_CLI_VERSION)" \
		--build-arg="HUB_EXTENSIONS_VERSION=$(HUB_EXTENSIONS_VERSION_COMMIT)" \
		--build-arg="HUB_STATE_VERSION=$(HUB_STATE_VERSION)" \
		--tag $(IMAGE):$(IMAGE_VERSION) \
		--tag $(IMAGE):latest .;
.PHONY: build

build-no-cache:
	$(MAKE) build DOCKER_BUILD_OPTS="--no-cache"
.PHONY: build-no-cache

push:
	$(docker) push $(IMAGE):$(IMAGE_VERSION)
	$(docker) push $(IMAGE):latest
.PHONY: push
