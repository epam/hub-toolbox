.DEFAULT_GOAL := run

export IMAGE         ?= agilestacks/toolbox
export IMAGE_VERSION ?= wetty-$(shell git rev-parse HEAD | cut -c-7)
export IMAGE_TAG     ?= wetty

REGISTRY_PASS ?= ~/.docker/agilestacks.txt

docker            ?= docker

DOCKER_BUILD_OPTS := --no-cache

USER := agilestacks
PASSWORD := toolbox

build:
	$(docker) build \
		$(DOCKER_BUILD_OPTS) \
		--build-arg="username=$(USER)" \
		--build-arg="password=$(PASSWORD)" \
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

PORT := 3000

run:
	$(docker) run --rm -it -v $(shell pwd):$(shell pwd) -p 3000:$(PORT) agilestacks/toolbox:wetty
.PHONY: run
