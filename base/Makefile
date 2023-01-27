# Copyright 2023 EPAM Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.DEFAULT_GOAL := build

IMAGE         ?= ghcr.io/epam/hub-toolbox
IMAGE_VERSION := $(shell git rev-parse HEAD | cut -c-7)-base

HUB_CTL_VERSION    := latest
HUB_STATE_VERSION  := latest
HUB_EXTENSIONS_REF := stable

ifeq ($(HUB_CTL_VERSION),)
$(error HUB_CTL_VERSION cannot be empty)
endif

ifeq ($(HUB_STATE_VERSION),)
$(error HUB_STATE_VERSION cannot be empty)
endif

ifeq ($(HUB_EXTENSIONS_REF),)
$(error HUB_EXTENSIONS_REF cannot be empty)
endif

ifeq ($(HUB_CTL_VERSION),latest)
HUB_CTL_VERSION = $(shell curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/epam/hubctl/releases/latest" | jq -crM ".tag_name" | cut -c 2-)
endif

ifeq ($(HUB_STATE_VERSION),latest)
HUB_STATE_VERSION = $(shell curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/epam/hub-state/releases/latest" | jq -crM ".tag_name" | cut -c 2-)
endif

HUB_EXTENSIONS_VERSION_COMMIT := $(shell git ls-remote -q https://github.com/epam/hub-extensions.git $(HUB_EXTENSIONS_REF) 2>/dev/null | cut -c-7)

ifeq ($(HUB_EXTENSIONS_VERSION_COMMIT),)
$(error HUB_EXTENSIONS_REF wrong or does not exist)
endif

docker ?= docker

DOCKER_BUILD_OPTS := --platform="linux/amd64"

build:
	$(docker) buildx build \
		$(DOCKER_BUILD_OPTS) \
		--build-arg="HUB_CTL_VERSION=$(HUB_CTL_VERSION)" \
		--build-arg="HUB_EXTENSIONS_VERSION=$(HUB_EXTENSIONS_VERSION_COMMIT)" \
		--build-arg="HUB_STATE_VERSION=$(HUB_STATE_VERSION)" \
		--tag $(IMAGE):$(IMAGE_VERSION) \
		--tag $(IMAGE):base .;
.PHONY: build

push:
	$(docker) push $(IMAGE):$(IMAGE_VERSION)
.PHONY: push

run:
	$(docker) run --rm -it $(IMAGE):base
.PHONY: run
